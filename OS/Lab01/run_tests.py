#!/usr/bin/env python3
"""

Usage:
    python3 run_tests.py                    # run every testcases/*.json
    python3 run_tests.py testcases/tc03_one_bad.json   # run just one
"""

import glob
import json
import os
import subprocess
import sys

TIMEOUT_SECS = 30
GCC_BUILD = ["gcc", "-Wall", "-Wextra", "-o", "parmake", "parmake.c"]


def clean(output_binary):
    """Remove object files and the output binary between tests."""
    for path in glob.glob("*.o"):
        os.remove(path)
    if output_binary and os.path.exists(output_binary):
        os.remove(output_binary)


def fail(name, details):
    print(f"FAIL  {name}")
    for line in details:
        print(f"      {line}")
    return False


def run_test(tc_path):
    with open(tc_path) as fh:
        tc = json.load(fh)
    name = tc.get("name", os.path.basename(tc_path))
    output_binary = tc["output"]
    cmd = ["./parmake", "-o", output_binary] + tc["sources"]

    clean(output_binary)
    try:
        proc = subprocess.run(
            cmd, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, timeout=TIMEOUT_SECS
        )
    except subprocess.TimeoutExpired:
        clean(output_binary)
        return fail(
            name,
            [
                f"timed out after {TIMEOUT_SECS}s.",
                "Is the parent wait()ing for more children than it "
                "created, or did a child fall through into the "
                "parent's code after a failed exec?",
            ],
        )

    details = []

    got = sorted(line for line in proc.stdout.splitlines() if line.strip())
    want = sorted(f"FAILED: {src}" for src in tc["expected_failed"])
    if got != want:
        details.append("output mismatch:")
        details.append(f"    expected: {want}")
        details.append(f"    got:      {got}")

    if proc.returncode != tc["expected_exit"]:
        details.append(f"exit code: expected {tc['expected_exit']}, " f"got {proc.returncode}")

    if tc["expected_exit"] == 0:
        if not os.path.exists(output_binary):
            details.append(f"output binary '{output_binary}' was not created")
        else:
            run = subprocess.run(
                ["./" + output_binary],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
                timeout=TIMEOUT_SECS,
            )
            if run.returncode != 0:
                details.append(f"linked binary '{output_binary}' exited " f"with {run.returncode}")
    else:
        if os.path.exists(output_binary):
            details.append(
                f"output binary '{output_binary}' exists. "
                "Linking must be skipped when any compile fails"
            )

    clean(output_binary)
    if details:
        return fail(name, details)
    print(f"PASS  {name}")
    return True


def main():
    os.chdir(os.path.dirname(os.path.abspath(__file__)))

    print("building parmake from parmake.c ...")
    if subprocess.run(GCC_BUILD).returncode != 0:
        sys.exit("parmake.c does not compile. Fix that first.")

    tests = sys.argv[1:] or sorted(glob.glob("testcases/*.json"))
    if not tests:
        sys.exit("no test cases found in testcases/")

    results = [run_test(t) for t in tests]
    passed = sum(results)
    print(f"\n{passed}/{len(results)} sample tests passed")
    sys.exit(0 if passed == len(results) else 1)


if __name__ == "__main__":
    main()
