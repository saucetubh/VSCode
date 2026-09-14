#!/usr/bin/env python3

import argparse
import glob
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile


def run_orchestrator(orchestrator, programs_dir, timeout):
    try:
        result = subprocess.run(
            [orchestrator, programs_dir],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            timeout=timeout,
        )
        return result.stdout.splitlines(), result.returncode, False
    except subprocess.TimeoutExpired as e:
        out = e.stdout or ""
        if isinstance(out, bytes):
            out = out.decode(errors="replace")
        return out.splitlines(), None, True


def build_scenario_dir(base_dir, fault, tmp_root):
    if fault is None:
        return base_dir

    scenario_dir = os.path.join(
        tmp_root,
        "scenario_%s_%s" % (fault["proc_id"], fault["faulty_binary"]),
    )
    os.makedirs(scenario_dir, exist_ok=True)

    for i in range(1, 9):
        link_path = os.path.join(scenario_dir, "prog%d" % i)
        if os.path.exists(link_path) or os.path.islink(link_path):
            continue

        if i == fault["proc_id"]:
            target = os.path.abspath(
                os.path.join(base_dir, fault["faulty_binary"])
            )
        else:
            target = os.path.abspath(os.path.join(base_dir, "prog%d" % i))

        os.symlink(target, link_path)

    return scenario_dir



PROC_PATTERNS = [
    (
        re.compile(r"^P(\d+) (START|END|TICK)(?: (\d+))?$"),
        {},
    ),
]

ERROR_RE = re.compile(r"^ERROR: P(\d+) exited with code (-?\d+)$")
TIMEOUT_RE = re.compile(r"^TIMEOUT: P(\d+) exceeded (\d+)s$")


def detect_wording(programs_dir):
    probe = os.path.join(programs_dir, "prog1")
    if not (os.path.isfile(probe) and os.access(probe, os.X_OK)):
        return None

    try:
        result = subprocess.run(
            [probe],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            timeout=5,
        )
    except (subprocess.TimeoutExpired, OSError):
        return None

    for pattern, normalize in PROC_PATTERNS:
        for line in result.stdout.splitlines():
            if pattern.match(line):
                return (pattern, normalize)

    return None


def parse_events(lines, active_pattern=None):
    patterns = [active_pattern] if active_pattern else PROC_PATTERNS
    events_by_key = {}
    errors = []
    timeouts = []

    for seq, line in enumerate(lines):
        matched = False

        for pattern, normalize in patterns:
            match = pattern.match(line)
            if match:
                proc_id, event = match.group(1), match.group(2)
                event = normalize.get(event, event)
                key = "P%s:%s" % (proc_id, event)
                events_by_key.setdefault(key, []).append(seq)
                matched = True
                break

        if matched:
            continue

        match = ERROR_RE.match(line)
        if match:
            errors.append((seq, int(match.group(1)), int(match.group(2))))
            continue

        match = TIMEOUT_RE.match(line)
        if match:
            timeouts.append((seq, int(match.group(1)), int(match.group(2))))

    return events_by_key, errors, timeouts


def check_exists_once(ctx, keys):
    for key in keys:
        occurrences = ctx["events"].get(key, [])
        if len(occurrences) != 1:
            return False, "expected exactly one '%s', found %d" % (
                key, len(occurrences)
            )
    return True, ""


def check_order(ctx, sequence):
    indexes = []
    for key in sequence:
        occurrences = ctx["events"].get(key, [])
        if not occurrences:
            return False, "missing event '%s'" % key
        indexes.append(occurrences[0])

    for a, b in zip(indexes, indexes[1:]):
        if not a < b:
            return False, "ordering violated: expected %s" % (sequence,)

    return True, ""


def check_overlap_any(ctx, pairs):
    checked = []
    for a, b in pairs:
        a_start = ctx["events"].get("%s:START" % a, [])
        a_end = ctx["events"].get("%s:END" % a, [])
        b_start = ctx["events"].get("%s:START" % b, [])
        b_end = ctx["events"].get("%s:END" % b, [])

        if not (a_start and a_end and b_start and b_end):
            continue

        checked.append((a, b))
        if a_start[0] < b_end[0] and b_start[0] < a_end[0]:
            return True, "%s and %s overlapped" % (a, b)

    return False, "no overlapping pair found among %s" % (checked or pairs)


def check_no_events_between(ctx, between, forbidden_events):
    lo_key, hi_key = between
    lo = ctx["events"].get(lo_key, [])
    hi = ctx["events"].get(hi_key, [])

    if not lo or not hi:
        return False, "missing window bounds %s" % (between,)

    lo_idx, hi_idx = lo[0], hi[0]
    for forbidden in forbidden_events:
        for idx in ctx["events"].get(forbidden, []):
            if lo_idx < idx < hi_idx:
                return False, "forbidden event '%s' occurred during %s" % (
                    forbidden, between
                )

    return True, ""


def check_count_min(ctx, event, minimum):
    count = len(ctx["events"].get(event, []))
    if count < minimum:
        return False, "expected at least %d occurrences of '%s', found %d" % (
            minimum, event, count
        )
    return True, ""


def check_count_before(ctx, event, minimum, before_event):
    before_idx = ctx["events"].get(before_event, [None])[0]
    if before_idx is None:
        return False, "missing anchor event '%s'" % before_event
    count = sum(1 for idx in ctx["events"].get(event, []) if idx < before_idx)
    if count < minimum:
        return False, "expected >= %d '%s' before '%s', found %d" % (
            minimum, event, before_event, count
        )
    return True, ""


def check_count_after(ctx, event, minimum, after_event):
    after_idx = ctx["events"].get(after_event, [None])[0]
    if after_idx is None:
        return False, "missing anchor event '%s'" % after_event
    count = sum(1 for idx in ctx["events"].get(event, []) if idx > after_idx)
    if count < minimum:
        return False, "expected >= %d '%s' after '%s', found %d" % (
            minimum, event, after_event, count
        )
    return True, ""


def check_error_message(ctx, proc_id, exit_code=None):
    for _seq, pid, code in ctx["errors"]:
        if pid == proc_id and (exit_code is None or code == exit_code):
            return True, ""

    return False, "expected error message for P%d" % proc_id


def check_timeout_message(ctx, proc_id, threshold=None):
    for _seq, pid, timeout in ctx["timeouts"]:
        if pid == proc_id and (
            threshold is None or timeout == threshold
        ):
            return True, ""

    return False, "expected timeout message for P%d" % proc_id


def check_no_timeout_message(ctx, proc_id):
    for _seq, pid, _timeout in ctx["timeouts"]:
        if pid == proc_id:
            return False, "unexpected timeout message for P%d" % proc_id
    return True, ""


def check_absent(ctx, events):
    for key in events:
        if ctx["events"].get(key):
            return False, "unexpected event '%s'" % key
    return True, ""


def check_clean_run(ctx):
    if ctx["errors"] or ctx["timeouts"]:
        return False, "unexpected ERROR/TIMEOUT message"
    return True, ""


def check_exit_success(ctx):
    if ctx["timed_out"]:
        return False, "orchestrator timed out"
    if ctx["returncode"] not in (0, None):
        return False, "orchestrator exited with status %s" % ctx["returncode"]
    return True, ""


CHECKERS = {
    "exists_once": lambda ctx, c: check_exists_once(ctx, c["events"]),
    "order": lambda ctx, c: check_order(ctx, c["sequence"]),
    "overlap_any": lambda ctx, c: check_overlap_any(ctx, c["pairs"]),
    "no_events_between": lambda ctx, c: check_no_events_between(
        ctx, c["between"], c["forbidden_events"]
    ),
    "count_min": lambda ctx, c: check_count_min(
        ctx, c["event"], c["min"]
    ),
    "count_before": lambda ctx, c: check_count_before(
        ctx, c["event"], c["min"], c["before"]
    ),
    "count_after": lambda ctx, c: check_count_after(
        ctx, c["event"], c["min"], c["after"]
    ),
    "absent": lambda ctx, c: check_absent(ctx, c["events"]),
    "error_message": lambda ctx, c: check_error_message(
        ctx, c["proc_id"], c.get("exit_code")
    ),
    "timeout_message": lambda ctx, c: check_timeout_message(
        ctx, c["proc_id"], c.get("threshold")
    ),
    "no_timeout_message": lambda ctx, c: check_no_timeout_message(
        ctx, c["proc_id"]
    ),
    "clean_run": lambda ctx, c: check_clean_run(ctx),
    "exit_success": lambda ctx, c: check_exit_success(ctx),
}


def run_checks(ctx, checks):
    ok_all = True
    reasons = []

    for check in checks:
        fn = CHECKERS.get(check["type"])
        if fn is None:
            ok_all = False
            reasons.append("unknown check type '%s'" % check["type"])
            continue

        ok, reason = fn(ctx, check)
        if not ok:
            ok_all = False
            reasons.append("[%s] %s" % (check["type"], reason))

    return ok_all, reasons


def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    ap.add_argument("--orchestrator", required=True)
    ap.add_argument("--programs-dir", required=True)
    ap.add_argument("--tests-dir", required=True)
    ap.add_argument("--timeout", type=float, default=20.0)
    ap.add_argument("--verbose", action="store_true")
    args = ap.parse_args()

    if not os.path.isfile(args.orchestrator) or not os.access(
        args.orchestrator, os.X_OK
    ):
        print("ERROR: orchestrator not found or not executable: %s" % args.orchestrator)
        sys.exit(2)

    test_files = sorted(glob.glob(os.path.join(args.tests_dir, "*.json")))
    if not test_files:
        print("ERROR: no *.json test files found in %s" % args.tests_dir)
        sys.exit(2)

    tests = []
    for path in test_files:
        with open(path, encoding="utf-8") as f:
            tests.append((path, json.load(f)))

    # Tests with the same fault share one orchestrator run.
    scenario_of = {}
    for _path, test in tests:
        fault = test.get("fault")
        key = None if fault is None else (
            fault["proc_id"], fault["faulty_binary"]
        )
        scenario_of[key] = fault

    tmp_root = tempfile.mkdtemp(prefix="oslab_grade_")
    scenario_ctx = {}

    try:
        active_pattern = detect_wording(args.programs_dir)

        for key, fault in scenario_of.items():
            run_dir = build_scenario_dir(args.programs_dir, fault, tmp_root)
            lines, returncode, timed_out = run_orchestrator(
                args.orchestrator, run_dir, args.timeout
            )

            if args.verbose:
                print("----- captured output -----")
                for line in lines:
                    print(line)
                print("----- end captured output -----")

            events, errors, timeouts = parse_events(lines, active_pattern)
            scenario_ctx[key] = {
                "events": events,
                "errors": errors,
                "timeouts": timeouts,
                "returncode": returncode,
                "timed_out": timed_out,
            }

        # Every testcase is worth exactly one mark.
        total_points = len(tests)
        earned_points = 0

        print("\nTEST  RESULT")
        print("------------")

        for index, (_path, test) in enumerate(tests, start=1):
            fault = test.get("fault")
            key = None if fault is None else (
                fault["proc_id"], fault["faulty_binary"]
            )
            ctx = scenario_ctx[key]

            ok, reasons = run_checks(ctx, test["checks"])
            if ok:
                earned_points += 1

            print("%4d  %s" % (index, "PASS" if ok else "FAIL"))

            if not ok and args.verbose:
                for reason in reasons:
                    print("      - %s" % reason)

        print("------------")
        print("TOTAL: %d/%d" % (earned_points, total_points))

    finally:
        shutil.rmtree(tmp_root, ignore_errors=True)


if __name__ == "__main__":
    main()
