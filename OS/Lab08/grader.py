#!/usr/bin/env python3
"""Build and test Lab 8 using the supplied command driver."""

import argparse
import difflib
import json
import os
import re
from pathlib import Path
import selectors
import signal
import subprocess
import sys
import tempfile
import time
from typing import NamedTuple


ROOT = Path(__file__).resolve().parent
BUILD = ROOT / ".build" / "grader" / "paging_lab"
TIMEOUT = 5
OUTPUT_LIMIT = 1024 * 1024  # Per stream, in bytes.
DISPLAY_LIMIT = 8000
SUBMISSION = ('paging.c', 'sim_framework.c')
CC = ('gcc', '-Wall', '-Wextra', '-g')
COMPARISON = 'exact-stable-v1'

OBSERVER_SOURCE = r"""/* Grading checks for frame mappings and swap-slot use.
 * Added to a temporary source copy when running make test. */
static bool lab08_reserved[MAX_SWAP_SLOTS], lab08_had_backing[NUM_PAGES];
static FILE *lab08_observations;
static size_t lab08_command, lab08_limit, lab08_transfer_count;
static int lab08_access_page = -1;
static int lab08_first_slot[NUM_PAGES];
static struct { int page, slot; } lab08_transfers[128];

static void lab08_invalid(const char *reason) {
    fprintf(stderr, "[LAB08 INVARIANT] %s\n", reason);
    exit(98);
}

static void lab08_check_slot(int slot) {
    if (slot < 0 || slot >= MAX_SWAP_SLOTS || !lab08_reserved[slot])
        lab08_invalid("swap transfer uses a slot not reserved by the allocator");
}

static void lab08_record_transfer(int page, int slot) {
    lab08_check_slot(slot);
    if (page < 0 || page >= NUM_PAGES || sim_get_page_info(page).type != PAGE_ANON)
        lab08_invalid("swap transfer has no anonymous-page owner");
    if (lab08_transfer_count == 128)
        lab08_invalid("too many swap transfers in one access");
    lab08_transfers[lab08_transfer_count].page = page;
    lab08_transfers[lab08_transfer_count++].slot = slot;
}

int sim_alloc_swap_slot(void) {
    int slot = lab08_original_sim_alloc_swap_slot();
    if (slot < 0 || slot >= MAX_SWAP_SLOTS || lab08_reserved[slot])
        lab08_invalid("allocator returned an invalid or already-reserved slot");
    lab08_reserved[slot] = true;
    return slot;
}

void sim_free_swap_slot(int slot) {
    for (int p = 0; p < NUM_PAGES; p++)
        if (lab08_had_backing[p] && lab08_first_slot[p] == slot)
            lab08_invalid("an assigned backing slot must remain reserved for the run");
    if (slot >= 0 && slot < MAX_SWAP_SLOTS) lab08_reserved[slot] = false;
    lab08_original_sim_free_swap_slot(slot);
}

void sim_read_from_swap(int frame, int slot) {
    lab08_record_transfer(lab08_access_page, slot);
    lab08_original_sim_read_from_swap(frame, slot);
}

void sim_write_to_swap(int frame, int slot) {
    int owner = -1;
    for (int p = 0; p < sim_page_count(); p++) {
        PageInfo page = sim_get_page_info(p);
        if (page.resident && page.frame_id == frame) owner = p;
    }
    lab08_record_transfer(owner, slot);
    lab08_original_sim_write_to_swap(frame, slot);
}

void lab08_grader_open(const char *path, size_t commands) {
    lab08_limit = commands;
    lab08_observations = fopen(path, "w");
    if (lab08_observations == NULL) {
        perror("[LAB08 OBSERVER ERROR] fopen");
        exit(99);
    }
}

void lab08_grader_begin_access(int page) { lab08_access_page = page; }

void lab08_grader_after_command(void) {
    int owner[NUM_FRAMES], slot_owner[MAX_SWAP_SLOTS];
    for (int f = 0; f < NUM_FRAMES; f++) owner[f] = -1;
    for (int s = 0; s < MAX_SWAP_SLOTS; s++) slot_owner[s] = -1;
    if (sim_page_count() != NUM_PAGES || lab08_command >= lab08_limit)
        lab08_invalid("unexpected page count or extra command observation");
    for (int p = 0; p < NUM_PAGES; p++) {
        PageInfo page = sim_get_page_info(p);
        if (page.resident) {
            if (page.frame_id < 0 || page.frame_id >= NUM_FRAMES || owner[page.frame_id] != -1)
                lab08_invalid("invalid or overlapping resident frame mappings");
            owner[page.frame_id] = p;
        } else if (page.frame_id != -1) {
            lab08_invalid("nonresident page retains a frame mapping");
        }
        int slot = page.swap_slot;
        if (slot == -1) {
            if (lab08_had_backing[p]) lab08_invalid("a page lost its retained backing");
            continue;
        }
        lab08_check_slot(slot);
        if (page.type != PAGE_ANON || slot_owner[slot] != -1)
            lab08_invalid("backing belongs to a file page or multiple pages");
        if (lab08_had_backing[p] && lab08_first_slot[p] != slot)
            lab08_invalid("a page changed its assigned backing slot");
        slot_owner[slot] = p;
        lab08_first_slot[p] = slot;
        lab08_had_backing[p] = true;
    }
    /* Check after the command finishes so the slot can be recorded
     * before or after its first write. */
    for (size_t i = 0; i < lab08_transfer_count; i++)
        if (sim_get_page_info(lab08_transfers[i].page).swap_slot != lab08_transfers[i].slot)
            lab08_invalid("swap transfer does not use its page's recorded backing");
    lab08_transfer_count = 0;
    fprintf(lab08_observations, "%zu", ++lab08_command);
    for (int f = 0; f < NUM_FRAMES; f++) fprintf(lab08_observations, " %d", owner[f]);
    fputc('\n', lab08_observations);
}

void lab08_grader_close(void) {
    if (lab08_command != lab08_limit) lab08_invalid("missing command observations");
    if (fclose(lab08_observations) != 0) {
        perror("[LAB08 OBSERVER ERROR] fclose");
        exit(99);
    }
}
"""


class Result(NamedTuple):
    returncode: int
    stdout: bytes
    stderr: bytes
    reason: str = None


def kill_process_group(pid):
    try:
        os.killpg(pid, signal.SIGKILL)
    except ProcessLookupError:
        pass


def run_command(command, timeout=TIMEOUT, output_limit=OUTPUT_LIMIT):
    """Run a command with time and output limits."""
    process = subprocess.Popen(
        list(map(str, command)), cwd=ROOT,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE, start_new_session=True,
    )
    selector = selectors.DefaultSelector()
    output = {"stdout": bytearray(), "stderr": bytearray()}
    reason = None
    deadline = time.monotonic() + timeout
    drain_deadline = None
    try:
        selector.register(process.stdout, selectors.EVENT_READ, "stdout")
        selector.register(process.stderr, selectors.EVENT_READ, "stderr")
        while selector.get_map() or process.poll() is None:
            now = time.monotonic()
            if now >= deadline and process.poll() is None and reason is None:
                reason = f"timeout after {timeout:g} seconds"
            if drain_deadline is None and (reason or process.poll() is not None):
                kill_process_group(process.pid)
                drain_deadline = now + 0.5
            if drain_deadline is not None and now >= drain_deadline:
                break
            for key, _ in selector.select(0.05):
                pipe, stream = key.fileobj, key.data
                data = os.read(pipe.fileno(), 65536)
                if not data:
                    selector.unregister(pipe)
                    pipe.close()
                    continue
                remaining = output_limit - len(output[stream])
                output[stream].extend(data[:remaining])
                if len(data) > remaining and reason is None:
                    reason = f"output-limit failure: {stream} exceeded {output_limit} bytes"
        process.wait(timeout=1)
    finally:
        kill_process_group(process.pid)
        selector.close()
        for pipe in (process.stdout, process.stderr):
            pipe.close()
        process.wait(timeout=1)
    return Result(process.returncode, bytes(output["stdout"]),
                  bytes(output["stderr"]), reason)


def clipped(text, limit=DISPLAY_LIMIT):
    if len(text) <= limit:
        return text
    return text[:limit] + f"\n... [{len(text) - limit} characters omitted] ...\n"


def print_block(label, value):
    print(f"--- {label}")
    value = clipped(value)
    print(value, end="" if value.endswith("\n") else "\n")


def build():
    sources = [ROOT / name for name in
               ("sim_framework.c", "paging.c", "paging_test_driver.c")]
    for path in sources + [ROOT / "paging_sim.h"]:
        if not path.is_file():
            raise RuntimeError(f"Required source file not found: {path.name}")
    BUILD.parent.mkdir(parents=True, exist_ok=True)
    BUILD.unlink(missing_ok=True)
    result = run_command(
        ["gcc", "-Wall", "-Wextra", "-g", *sources, "-o", BUILD],
        timeout=30,
    )
    if result.stdout:
        print_block("Compiler stdout", result.stdout.decode("utf-8", errors="replace"))
    if result.stderr:
        print_block("Compiler stderr", result.stderr.decode("utf-8", errors="replace"))
    if result.returncode or result.reason:
        raise RuntimeError(f"Compilation failed ({result.reason or 'see compiler output'}).")
    print("Built paging.c, sim_framework.c, and the supplied command driver.")


def expected_output_path(source):
    source = Path(source)
    folder = source.parent.parent / "outputs"
    if not folder.is_dir():
        folder = source.parent.parent / "solutions"
    return folder / f"{source.stem}.json"


def load_cases(suite):
    test_dir = ROOT / suite / "tests"
    cases = []
    for source in sorted(test_dir.glob("*.txt")):
        expected_path = expected_output_path(source)
        if not expected_path.is_file():
            raise RuntimeError(f"Missing expected-output file: {expected_path.relative_to(ROOT)}")
        data = json.loads(expected_path.read_text(encoding="utf-8"))
        if not isinstance(data, dict) or not all(
                isinstance(data.get(key), str) for key in ("name", "expected_output")):
            raise RuntimeError(f"Invalid expected-output JSON: {expected_path.relative_to(ROOT)}")
        cases.append((source, data["name"], data["expected_output"]))
    if not cases:
        raise RuntimeError(f"No test cases found in {test_dir.relative_to(ROOT)}.")
    return cases


def selected(value, total):
    if not value.strip():
        return list(range(1, total + 1))
    try:
        numbers = list(dict.fromkeys(int(part) for part in value.split()))
    except ValueError as error:
        raise RuntimeError('Use N=3 or N="1 2 3" to select tests.') from error
    if any(number < 1 or number > total for number in numbers):
        raise RuntimeError(f"Test numbers must be between 1 and {total}.")
    return numbers


def failure_reason(result, expected):
    if result.reason:
        return result.reason
    if result.returncode < 0:
        try:
            name = signal.Signals(-result.returncode).name
        except ValueError:
            name = f"signal {-result.returncode}"
        return f"crash/signal: {name}"
    if result.returncode:
        return f"nonzero exit status: {result.returncode}"
    try:
        actual = result.stdout.decode("utf-8")
    except UnicodeDecodeError:
        return "invalid UTF-8 output"
    if actual != expected:
        return "output mismatch"
    return None


def print_diff(expected, actual, reason):
    print("--- Unified diff")
    if reason and reason.startswith("output-limit failure:"):
        print("(diff omitted because output exceeded the limit)")
        return
    remaining = DISPLAY_LIMIT
    changed = False
    for line in difflib.unified_diff(expected.splitlines(True), actual.splitlines(True),
                                     fromfile="Expected", tofile="Your output"):
        changed = True
        if len(line) > remaining:
            print(line[:remaining], end="")
            print("\n... [remaining diff omitted] ...")
            return
        print(line, end="" if line.endswith("\n") else "\n")
        if not line.endswith("\n"):
            print("\\ No newline at end of file")
        remaining -= len(line)
    if not changed:
        print("(no differences)")


def check(expected,actual,wanted_maps,observations):
    if actual != expected:return 'output mismatch',None
    try:observed=[list(map(int,line.split())) for line in observations.splitlines()]
    except ValueError:return 'malformed frame observations',None
    for index in range(max(len(wanted_maps),len(observed))):
        wanted=[index+1,*wanted_maps[index]] if index<len(wanted_maps) else []
        actual_map=observed[index] if index<len(observed) else []
        if wanted!=actual_map:return f'frame ownership differs after command {index+1}',dict(
            command=index+1,expected=str(wanted),actual=str(actual_map))
    return None,None

def instrument(framework,driver):
    # Ignore comments and string literals when locating function definitions.
    noncode=re.compile(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',re.S)
    for name in ('sim_alloc_swap_slot','sim_free_swap_slot','sim_read_from_swap','sim_write_to_swap'):
        masked=noncode.sub(lambda m:''.join('\n' if c=='\n' else ' ' for c in m[0]),framework)
        pattern=r'(?m)^\s*(?:int|void)\s+('+name+r')\s*\([^;{}]*\)\s*\{'
        matches=list(re.finditer(pattern,masked))
        if len(matches)!=1:raise ValueError(f'Expected supplied definition of {name}')
        start,end=matches[0].span(1)
        framework=framework[:start]+'lab08_original_'+framework[start:]
    framework+='\n'+OBSERVER_SOURCE
    declarations='''
void lab08_grader_open(const char *, size_t);
void lab08_grader_begin_access(int);
void lab08_grader_after_command(void);
void lab08_grader_close(void);
'''
    driver=driver.replace('#include <string.h>','#include <string.h>\n'+declarations)
    driver=driver.replace('            uint8_t value = read_virtual_memory',
        '            lab08_grader_begin_access(page_id);\n            uint8_t value = read_virtual_memory')
    driver=driver.replace('            write_virtual_memory(page_id, offset, (uint8_t)value);',
        '            lab08_grader_begin_access(page_id);\n            write_virtual_memory(page_id, offset, (uint8_t)value);')
    needle='''    }

    return 1;
}'''
    if driver.count(needle)!=1:raise ValueError('Unexpected supplied driver structure')
    driver=driver.replace(needle,'''        lab08_grader_after_command();
    }

    return 1;
}''')
    driver=driver.replace('argc != 2','argc != 4')
    driver=driver.replace('    sim_init();','    sim_init();\n    lab08_grader_open(argv[2], (size_t)strtoul(argv[3], NULL, 10));')
    driver=driver.replace('    fclose(input);','    lab08_grader_close();\n    fclose(input);')
    return framework,driver

def compile_submission(submission,stage):
    stage=Path(stage);stage.mkdir(parents=True,exist_ok=True)
    for name in SUBMISSION:(stage/name).write_bytes((Path(submission)/name).read_bytes())
    (stage/'paging_sim.h').write_bytes((ROOT/'paging_sim.h').read_bytes())
    framework,driver=instrument((stage/'sim_framework.c').read_text(),(ROOT/'paging_test_driver.c').read_text())
    (stage/'sim_framework.c').write_text(framework);(stage/'paging_test_driver.c').write_text(driver)
    binary=stage/'paging_lab'
    command=[*CC,*(stage/n for n in ('sim_framework.c','paging.c','paging_test_driver.c')),'-o',binary]
    return binary,command,run_command(command,timeout=30)

def run_case(binary,source,expected,observed):
    fixture=json.loads(expected_output_path(source).read_text())
    wanted=fixture['semantic']['frame_owners'];observed=Path(observed);observed.unlink(missing_ok=True)
    result=run_command([binary,source,observed,str(len(wanted))]);diff=None
    if b'[LAB08 OBSERVER ERROR]' in result.stderr:raise RuntimeError('The grader could not record the frame mappings.')
    if result.reason or result.returncode:
        reason=failure_reason(result,expected)
        invariant=re.search(rb'\[LAB08 INVARIANT\] ([^\n]+)',result.stderr)
        if invariant:reason='invalid backing/mapping: '+invariant[1].decode(errors='replace')
    else:
        try:reason,diff=check(expected,result.stdout.decode('utf-8'),wanted,
                              observed.read_text() if observed.exists() else '')
        except UnicodeDecodeError:reason='invalid UTF-8 output'
    return result,reason,diff


def test(cases, numbers):
    passed = 0
    with tempfile.TemporaryDirectory(prefix="lab08 public checks ") as directory:
        stage = Path(directory)
        binary, command, compiled = compile_submission(ROOT, stage)
        for stream in ("stdout", "stderr"):
            data = getattr(compiled, stream)
            if data: print_block(f"Compiler {stream}", data.decode("utf-8", errors="replace"))
        if compiled.returncode or compiled.reason:
            raise RuntimeError(f"Compilation failed ({compiled.reason or 'see compiler output'}).")
        print("Compiled your code.")
        for number in numbers:
            source, name, expected = cases[number - 1]
            result, reason, diff = run_case(binary, source, expected, stage / "observations.txt")
            passed += reason is None
            print(f"\nTest {number}: {name}: {'PASS' if reason is None else 'FAIL'}")
            print(f"Input/test file: {source.relative_to(ROOT)}")
            if reason and reason != "output mismatch":
                print(f"Failure reason: {reason}")
            if reason:
                print(f"Re-run: make test N={number}")
                print(f"Run manually: make run N={number}")
            actual = result.stdout.decode("utf-8", errors="replace")
            print_block("Expected output", expected)
            print_block("Your output", actual)
            print_diff(expected, actual, reason)
            if result.stderr:
                print_block("Program stderr", result.stderr.decode("utf-8", errors="replace"))
    print(f"\nSummary: {passed}/{len(numbers)} passed")
    return 0 if passed == len(numbers) else 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["build", "test", "list"])
    parser.add_argument("--suite", choices=["public"], default="public")
    parser.add_argument("--n", default="", help="space-separated test numbers")
    args = parser.parse_args()
    try:
        if args.action == "build":
            build()
            return 0
        cases = load_cases(args.suite)
        numbers = selected(args.n, len(cases))
        if args.action == "list":
            for number in numbers:
                source, name, _ = cases[number - 1]
                print(f"{number}: {name} ({source.relative_to(ROOT)})")
            return 0
        return test(cases, numbers)
    except KeyboardInterrupt:
        print("\nInterrupted.", file=sys.stderr)
        return 130
    except (RuntimeError, OSError, ValueError, subprocess.TimeoutExpired) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
