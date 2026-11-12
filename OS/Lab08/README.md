# Lab 8: Demand Paging with Enhanced Clock

## Preface

**TA Crash Man** is reviewing lab submissions when he runs out of memory.
**TA Arnold Add-a-TV** suggests evicting whichever page was used least recently.

Crash Man starts keeping a list of page accesses. After spending more time
updating the list than reviewing the submissions, he decides that a tick beside
each page should be enough to remember whether it was used.

Arnold suggests trying Enhanced Clock. Crash Man declares the idea complete and
leaves you to implement it.

## The Task

In this lab, you must implement demand paging in the given simulator, with the
Enhanced Clock page replacement policy described below. The simulator has 12
virtual pages, 4 physical frames, and each page is 64 bytes. Pages 0 through 5 are
anonymous, and pages 6 through 11 are file-backed. Initially, all frames are free.

Accessing a nonresident page causes a page fault. The provided handler finds
the lowest-numbered free frame, calling your selection and eviction functions
to make one available if all frames are occupied. It then calls your loading
function to bring the requested page into that frame, after which the original
access continues.

## Replacement Policy: Enhanced Clock

The LRU (least recently used) policy keeps track of the order in which resident
pages were last accessed. Maintaining this order requires additional storage
and updates on every access, which can be expensive. In threaded implementations,
synchronization is also needed, and lock contention when updating this order can
reduce performance.

The Clock policy approximates the LRU policy by storing a reference bit per page
(representing usage), avoiding the need to maintain this ordering and reducing
synchronization overhead.
The reference bit of a page is set whenever it is accessed (read from or written to) or loaded
(brought into a physical frame). Enhanced Clock, which you will be implementing
in this lab, additionally favours clean pages among the unreferenced ones for
eviction, saving some overhead of write-back.

To find a victim, the policy searches the physical frames in circular order,
like a hand moving around a clock face numbered 0, 1, 2, and 3. The hand initially
points to frame 0 and marks the starting point of the search. For example, a
search starting at frame 2 visits frames 2, 3, 0, and 1. Once a victim is selected,
the hand moves to the following frame, from which the next search starts.
Accesses that do not require replacement leave its position unchanged.

Each circular search stops when a victim is found or all four frames have been
examined. The policy works as follows:

1. Starting with the frame the hand is pointing at, search in circular order and
   select the first clean page whose reference bit is 0, if it exists.
2. If step 1 does not find a victim, start another circular search from the same
   starting frame. At each frame, select the page if it is dirty and its
   reference bit is 0. Otherwise, clear its reference bit and continue to the
   next frame.
3. If all four frames are examined without finding a victim in step 2, start
   again from step 1 with the original starting frame.

The page selected by the search above is the one to be evicted.

## Eviction and Loading

Your implementation must update the page and frame metadata as appropriate,
including the resident and dirty bits. During eviction, any contents that need
to be preserved must be saved before the frame is released.

### Anonymous pages

Anonymous pages initially contain only zeros, and their contents must be
preserved across eviction and reloading.

When evicting a dirty anonymous page, save its complete contents to swap. If the
page has no assigned swap slot, obtain one from the supplied allocator and
record it; otherwise, overwrite its existing slot. A page's swap slot is fixed
to the first one it is assigned for the rest of the program's execution, and
must not be released when the page is loaded or evicted.

Evicting a clean anonymous page should not write to swap space.

### File-backed pages

When evicting a dirty file-backed page, write its contents back using its recorded
file ID and file offset. A clean file-backed page needs no write-back. When
loading a file-backed page, read its complete contents using that same file ID
and offset.

## Where to Start

Read the entire README and starter code before making any changes.

The starter code already adds a reference bit to each page, as a `referenced` member of the `PageInfo` and `InternalPage` structs. The `sim_set_referenced()` function, implemented for you, lets you modify the reference bit for any page.

To complete the lab, you will need to complete tasks in `sim_framework.c` and `paging.c`.

In `sim_framework.c`, you will need to make changes to have the simulator work with the reference bit in the policy:

- `sim_get_page_info()` must include the reference bit in the returned page
  information used by the replacement policy.
- `read_virtual_memory()` must update the reference bit according to the policy
  for a read to a resident page.
- `write_virtual_memory()` must update the reference bit according to the policy
  for a write to a resident page.

In `paging.c`, you need to implement `select_victim_page()`, `evict_page()`,
and `load_page()` to cover victim selection, eviction and loading, respectively.

`select_victim_page()` should return the **page ID** chosen by the policy and make
the required changes to reference bits and the saved starting frame. The page
should remain resident until `evict_page()` saves its contents as required and releases
its frame. `load_page()` should restore or initialize a page in the free frame supplied
by the fault handler.

You may add your own variables and helper functions, but your paging code must
use the provided simulator APIs. Keep `paging_sim.h`, the supplied function
signatures, fault handler and command driver unchanged, and preserve the
existing metadata updates and output formats.

## Input and Output

Your code is run on commands from an input text file, with one command per line.
The commands tell the simulator what to do, and it calls your paging functions
when needed. The provided driver, `paging_test_driver.c`, reads the commands
and prints the results. You do not need to implement command handling or
modify the driver. The grader runs your implementation through this driver and 
compares the output with the expected output.


| Command | Effect |
| --- | --- |
| `READ <page> <offset>` | Reads the byte at offset `<offset>` within virtual page `<page>`. |
| `WRITE <page> <offset> <value>` | Writes the byte value `<value>` at offset `<offset>` within virtual page `<page>`. |
| `INFO <page>` | Prints the metadata of virtual page `<page>`. |
| `STATE` | Prints metadata for all pages. |
| `FAULT <page>` | Invokes the fault handler for nonresident virtual page `<page>`. |
| `EVICT <page>` | Evicts resident virtual page `<page>`, freeing its physical frame. |
| `LOAD <page> <frame>` | Loads nonresident virtual page `<page>` into free physical frame `<frame>`. |

Pages are numbered 0–11 and frames 0–3. Each page contains 64 bytes, addressed by
offsets 0–63. A `WRITE` command stores an unsigned byte value between 0 and 255.


## Building and Testing

```sh
make                        # compile the implementation
make run INPUT=commands.txt # compile and run using commands.txt
make run N=1                # run test 1's commands without grading
make test                   # run all tests with the grader
make test N=3               # check test 3 with the grader
make test N="1 3"           # check tests 1 and 3 with the grader
make list                   # list the tests
make clean                  # remove build output
```

The default `make` target only compiles the implementation files. `make run`
also links the supplied command driver and runs the simulator, printing its
output without comparing it against an expected result. Use either `INPUT` for
your own command file or `N` for one numbered test. `make test` runs the selected
tests through the grader and reports whether their results are correct.

The supplied tests are there to help you check your implementation. Additional
tests will be run during grading.

For each test, the grader shows the expected output, your output, and a unified
diff highlighting any differences. Compiler messages and output written to
`stderr` are also shown; `stderr` is not compared with the expected output.

## Examples

Each frame entry shows the page followed by its reference and dirty bits, in
that order. For example, `P0 (1,0)` means page 0 with reference bit 1 and dirty
bit 0; a dash denotes a free frame. Each row shows the state after its command.
“Next start” is the saved starting frame for the next victim search, and “Victim”
is the page ID selected by the command, if any.

### Small example

| Step | Command | Frame 0 | Frame 1 | Frame 2 | Frame 3 | Next start | Victim |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `READ 6 0` | `P6 (1,0)` | — | — | — | 0 | — |
| 2 | `WRITE 0 5 42` | `P6 (1,0)` | `P0 (1,1)` | — | — | 0 | — |
| 3 | `READ 7 0` | `P6 (1,0)` | `P0 (1,1)` | `P7 (1,0)` | — | 0 | — |
| 4 | `READ 8 0` | `P6 (1,0)` | `P0 (1,1)` | `P7 (1,0)` | `P8 (1,0)` | 0 | — |
| 5 | `READ 0 5` | `P6 (1,0)` | `P0 (1,1)` | `P7 (1,0)` | `P8 (1,0)` | 0 | — |
| 6 | `READ 9 0` | `P9 (1,0)` | `P0 (0,1)` | `P7 (0,0)` | `P8 (0,0)` | 1 | 6 |

The first four commands fill the frames, with page 0 dirty after the write at
step 2. The read at step 5 returns 42 from the resident page without requiring
a replacement. At step 6, no clean page has reference bit 0, so the search for a
dirty victim clears the reference bits of all four pages without selecting one.
The procedure then repeats from frame 0 and selects page 6, which is now clean
and unreferenced. Page 9 takes its place, and the hand moves to frame 1.

### Longer example

The following sequence also begins with a fresh simulator.

| Step | Command | Frame 0 | Frame 1 | Frame 2 | Frame 3 | Next start | Victim |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | `READ 8 0` | `P8 (1,0)` | — | — | — | 0 | — |
| 2 | `READ 2 0` | `P8 (1,0)` | `P2 (1,0)` | — | — | 0 | — |
| 3 | `WRITE 0 7 42` | `P8 (1,0)` | `P2 (1,0)` | `P0 (1,1)` | — | 0 | — |
| 4 | `WRITE 7 5 99` | `P8 (1,0)` | `P2 (1,0)` | `P0 (1,1)` | `P7 (1,1)` | 0 | — |
| 5 | `READ 10 0` | `P10 (1,0)` | `P2 (0,0)` | `P0 (0,1)` | `P7 (0,1)` | 1 | 8 |
| 6 | `READ 2 0` | `P10 (1,0)` | `P2 (1,0)` | `P0 (0,1)` | `P7 (0,1)` | 1 | — |
| 7 | `READ 11 0` | `P10 (1,0)` | `P2 (0,0)` | `P11 (1,0)` | `P7 (0,1)` | 3 | 0 |
| 8 | `READ 0 7` | `P10 (1,0)` | `P0 (1,0)` | `P11 (1,0)` | `P7 (0,1)` | 2 | 2 |
| 9 | `READ 1 0` | `P10 (1,0)` | `P0 (1,0)` | `P11 (0,0)` | `P1 (1,0)` | 0 | 7 |
| 10 | `READ 3 0` | `P10 (1,0)` | `P0 (1,0)` | `P3 (1,0)` | `P1 (1,0)` | 3 | 11 |
| 11 | `READ 4 0` | `P10 (0,0)` | `P0 (0,0)` | `P3 (0,0)` | `P4 (1,0)` | 0 | 1 |
| 12 | `READ 5 0` | `P5 (1,0)` | `P0 (0,0)` | `P3 (0,0)` | `P4 (1,0)` | 1 | 10 |
| 13 | `READ 6 0` | `P5 (1,0)` | `P6 (1,0)` | `P3 (0,0)` | `P4 (1,0)` | 2 | 0 |
| 14 | `READ 0 7` | `P5 (1,0)` | `P6 (1,0)` | `P0 (1,0)` | `P4 (1,0)` | 3 | 3 |

At step 7, the search begins at frame 1, but neither clean page has reference
bit 0. The search therefore restarts at frame 1 looking for a dirty page whose
reference bit is 0. It clears page 2's reference bit before reaching page 0,
which satisfies the condition and is selected. Although page 2 is now
unreferenced, the search continues according to step 2 rather than restarting
the search for a clean page. Page 0 is saved in swap slot 0, and the hand moves
to frame 3.

When page 0 is restored at step 8, swap slot 0 remains reserved as its backing copy.
The next fault, at step 9, evicts dirty file-backed page 7, whose changes must
be written back before its frame is reused. Page 0 is not modified after being
restored, so its eviction at step 13 requires no swap write; step 14 can still
recover the value 42 from its retained copy.

## Submission

Upload **`paging.c` and `sim_framework.c`** to local Quanta.
