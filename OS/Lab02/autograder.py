#!/usr/bin/env python3
"""Simple autograder for the task manager lab.

Runs ./task_manager --test-mode <tests/*.txt> and checks that each test
produces the expected output lines. The checks are presence-based so they
are not brittle to changing timestamps or pids.
"""

import os
import subprocess
import sys

BIN = "./task_manager"
TESTS_DIR = "tests"

# For each test file: lines that must appear, and lines that must NOT appear.
EXPECTATIONS = {
    "test1_basic.txt": {
        "must": ["started task 1", "started task 2", "task 1 exited", "task 2 exited"],
        "must_not": [],
    },
    "test2_pause_resume.txt": {
        "must": ["started task 1", "paused task 1", "resumed task 1", "task 1 exited"],
        "must_not": [],
    },
    "test3_terminate.txt": {
        "must": ["started task 1", "terminated task 1"],
        # A terminated task is killed, so it must not report a normal exit.
        "must_not": ["task 1 exited"],
    },
    "test4_many.txt": {
        "must": [
            "started task 1", "started task 2", "started task 3",
            "paused task 2", "terminated task 3", "resumed task 2",
            "task 1 exited", "task 2 exited",
        ],
        "must_not": ["task 3 exited"],
    },
    "test5_invalid_id.txt": {
        "must": ["started task 1", "paused task 99", "resumed task 99",
                 "terminated task 99", "task 1 exited"],
        "must_not": [],
    },
    "test6_pause_timing.txt": {
        "must": [
            "started task 1", "paused task 1", "resumed task 1", "task 1 exited",
        ],
        "must_not": [],
    },
    "test7_exec.txt": {
        "must": [
            "running /bin/echo", "hello from exec", "task 1 exited",
            "running /usr/bin/wc", "task 2 exited",
        ],
        "must_not": [],
    },
    "test8_exec_many.txt": {
        "must": [
            "started task 1", "for 2s", "running /bin/echo",
            "hello from exec", "task 1 exited", "task 2 exited",
        ],
        "must_not": [],
    },
}


def parse_events(output):
    """Return list of (timestamp, event) for lines like '[123.456] paused task 1'."""
    events = []
    for line in output.splitlines():
        if line.startswith("[") and "]" in line:
            ts = line[1:line.index("]")]
            try:
                ts = float(ts)
            except ValueError:
                continue
            events.append((ts, line[line.index("]") + 1:].strip()))
    return events


def run_test(name, expect):
    path = os.path.join(TESTS_DIR, name)
    if not os.path.exists(path):
        print(f"[{name}] FAIL: missing test file {path}")
        return False

    # Run in --test-mode: the program writes its output to output.txt.
    subprocess.run([BIN, "--test-mode", path],
                   capture_output=True, text=True, timeout=120)
    try:
        with open("output.txt") as fh:
            output = fh.read()
    except OSError:
        output = ""

    ok = True
    for needle in expect["must"]:
        if needle not in output:
            print(f"[{name}] FAIL: missing expected output: {needle!r}")
            ok = False

    for needle in expect["must_not"]:
        if needle in output:
            print(f"[{name}] FAIL: unexpected output: {needle!r}")
            ok = False

    # Timing check for the pause/resume test: the task must exit AFTER it is
    # resumed, and must not exit while it is paused.
    if name == "test6_pause_timing.txt":
        events = parse_events(output)
        by_event = {ev: ts for ts, ev in events}
        if ("paused task 1" in by_event and
                "resumed task 1" in by_event and
                "task 1 exited" in by_event):
            t_pause = by_event["paused task 1"]
            t_resume = by_event["resumed task 1"]
            t_exit = by_event["task 1 exited"]
            if not (t_resume <= t_exit):
                print(f"[{name}] FAIL: task exited before it was resumed "
                      f"(pause={t_pause}, resume={t_resume}, exit={t_exit})")
                ok = False
        else:
            print(f"[{name}] FAIL: could not find pause/resume/exit events for timing check")
            ok = False

    if ok:
        print(f"[{name}] PASS")
    return ok


def main():
    if not os.path.exists(BIN):
        print("error: build first (make)", file=sys.stderr)
        return 1

    results = {name: run_test(name, exp) for name, exp in EXPECTATIONS.items()}
    passed = sum(results.values())
    total = len(results)

    print(f"\n{passed}/{total} tests passed")
    return 0 if passed == total else 1


if __name__ == "__main__":
    sys.exit(main())
