#!/usr/bin/env python3
"""Command-file autograder for the demand-paging lab."""

import argparse
import difflib
import json
import os
import selectors
import signal
import subprocess
import sys
import time
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SOURCE_DIR = ROOT if (ROOT / "paging.c").is_file() else ROOT / "demand_paging_lab_student"
BUILD = ROOT / ".build" / "paging_lab"

TIMEOUT = 5
OUTPUT_LIMIT = 1024 * 1024  # 1 MiB per output stream.
DISPLAY_LIMIT = 2000


def build():
    """Compile the external command driver with the student's implementation."""
    paging_source = SOURCE_DIR / "paging.c"
    framework_source = SOURCE_DIR / "sim_framework.c"
    header = SOURCE_DIR / "paging_sim.h"
    driver_source = ROOT / "paging_test_driver.c"

    for path in (paging_source, framework_source, header, driver_source):
        if not path.is_file():
            raise RuntimeError(f"Required source file not found: {path}")

    BUILD.parent.mkdir(parents=True, exist_ok=True)
    result = subprocess.run(
        [
            "gcc",
            "-Wall",
            "-Wextra",
            "-std=c99",
            "-g",
            f"-I{SOURCE_DIR}",
            str(driver_source),
            str(paging_source),
            str(framework_source),
            "-o",
            str(BUILD),
        ],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )

    if result.stdout:
        print("--- Compiler stdout")
        print(result.stdout, end="")
    if result.stderr:
        print("--- Compiler stderr")
        print(result.stderr, end="")
    if result.returncode != 0:
        raise RuntimeError("Compilation failed.")

    print(f"Built {paging_source.relative_to(ROOT)}")


def selected(value, total):
    """Convert --n into a list of 1-based test numbers."""
    if total == 0:
        raise RuntimeError("No test cases found.")
    if not value:
        return list(range(1, total + 1))

    try:
        numbers = [int(part) for part in value.split()]
    except ValueError as error:
        raise RuntimeError(
            'N must contain test numbers, for example N=5 or N="1 2 3".'
        ) from error

    if any(number < 1 or number > total for number in numbers):
        raise RuntimeError(f"Test numbers must be between 1 and {total}.")
    return numbers


def kill_process_group(pid):
    """Stop the test process and any children it may have started."""
    try:
        os.killpg(pid, signal.SIGKILL)
    except ProcessLookupError:
        pass


def run_program(case):
    """Run one input file with a timeout and bounded stdout/stderr capture."""
    process = subprocess.Popen(
        [str(BUILD), str(case)],
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        start_new_session=True,
    )

    selector = selectors.DefaultSelector()
    selector.register(process.stdout, selectors.EVENT_READ, "stdout")
    selector.register(process.stderr, selectors.EVENT_READ, "stderr")
    output = {"stdout": bytearray(), "stderr": bytearray()}
    deadline = time.monotonic() + TIMEOUT
    reason = None

    try:
        while selector.get_map():
            if process.poll() is None and time.monotonic() >= deadline:
                reason = f"timeout after {TIMEOUT} seconds"
                kill_process_group(process.pid)

            if process.poll() is not None:
                kill_process_group(process.pid)

            for key, _ in selector.select(0.05):
                stream_name = key.data
                pipe = key.fileobj
                data = os.read(pipe.fileno(), 65536)
                if not data:
                    selector.unregister(pipe)
                    pipe.close()
                    continue

                output[stream_name] += data
                if len(output[stream_name]) > OUTPUT_LIMIT and reason is None:
                    reason = (
                        f"output-limit failure: {stream_name} exceeded "
                        f"{OUTPUT_LIMIT} bytes"
                    )
                    kill_process_group(process.pid)

        process.wait()
    except KeyboardInterrupt:
        kill_process_group(process.pid)
        for key in list(selector.get_map().values()):
            key.fileobj.close()
        selector.close()
        process.wait()
        raise
    finally:
        selector.close()

    return (
        process.returncode,
        bytes(output["stdout"]),
        bytes(output["stderr"]),
        reason,
    )


def truncate_output(text, limit):
    if len(text) <= limit:
        return text
    return text[:limit] + f"\n... [{len(text) - limit} characters omitted] ..."


def test(suite, choice):
    """Build the student program and compare selected traces to JSON outputs."""
    build()
    test_dir = ROOT / suite / "tests"
    solution_dir = ROOT / suite / "solutions"
    if not test_dir.is_dir():
        raise RuntimeError(f"Test directory not found: {test_dir}")
    if not solution_dir.is_dir():
        raise RuntimeError(f"Solution directory not found: {solution_dir}")

    cases = sorted(test_dir.glob("*.txt"))
    numbers = selected(choice, len(cases))
    passed = 0

    for number in numbers:
        case = cases[number - 1]
        solution_path = solution_dir / f"{case.stem}.json"
        if not solution_path.is_file():
            raise RuntimeError(f"Missing expected-output file: {solution_path}")

        data = json.loads(solution_path.read_text())
        if not isinstance(data.get("name"), str) or not isinstance(
            data.get("expected_output"), str
        ):
            raise RuntimeError(
                f"Invalid solution JSON schema in {solution_path}; expected "
                "string fields 'name' and 'expected_output'."
            )

        expected = data["expected_output"]
        code, stdout, stderr, reason = run_program(case)
        try:
            actual = stdout.decode("utf-8")
        except UnicodeDecodeError:
            actual = stdout.decode("utf-8", errors="replace")
            reason = "invalid UTF-8 output"
        stderr_text = stderr.decode("utf-8", errors="replace")

        if reason is None:
            if code < 0:
                try:
                    signal_name = signal.Signals(-code).name
                except ValueError:
                    signal_name = f"signal {-code}"
                reason = f"crash/signal: {signal_name}"
            elif code != 0:
                reason = f"nonzero exit status: {code}"
            elif actual != expected:
                reason = "output mismatch"

        passed_test = code == 0 and reason is None and actual == expected
        passed += passed_test

        print(f"\nTest {number}: {data['name']}: {'PASS' if passed_test else 'FAIL'}")
        print(f"Input/test file: {case.relative_to(ROOT)}")
        if not passed_test:
            print(f"Failure reason: {reason}")

        output_limit_failure = (
            reason is not None and reason.startswith("output-limit failure:")
        )
        expected_display = truncate_output(expected, DISPLAY_LIMIT) \
            if output_limit_failure else expected
        actual_display = truncate_output(actual, DISPLAY_LIMIT) \
            if output_limit_failure else actual

        print("--- Expected output")
        print(expected_display, end="" if expected_display.endswith("\n") else "\n")
        print("--- Your output")
        print(actual_display, end="" if actual_display.endswith("\n") else "\n")
        print("--- Unified diff")

        if output_limit_failure:
            print("(diff omitted because output exceeded the limit)")
        else:
            diff = "".join(
                difflib.unified_diff(
                    expected.splitlines(True),
                    actual.splitlines(True),
                    fromfile="Expected",
                    tofile="Your output",
                )
            )
            if diff:
                print(diff, end="")

        if stderr_text:
            print("--- Program stderr")
            stderr_display = (
                truncate_output(stderr_text, DISPLAY_LIMIT)
                if output_limit_failure else stderr_text
            )
            print(stderr_display, end="" if stderr_display.endswith("\n") else "\n")

    print(f"\nSummary: {passed}/{len(numbers)} passed")
    return 0 if passed == len(numbers) else 1


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=["build", "test"])
    parser.add_argument("--suite", choices=["public"], default="public")
    parser.add_argument("--n", default="")
    args = parser.parse_args()

    try:
        if args.action == "build":
            build()
            return 0
        return test(args.suite, args.n)
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        return 130
    except (RuntimeError, OSError, json.JSONDecodeError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
