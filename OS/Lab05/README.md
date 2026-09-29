# Lab05: Memory system calls - buddy allocator and shared memory

Run every command in this README from the root directory of the lab.

## Task 1: Buddy allocator

Memory allocation means reserving a region of memory for a program to store
data. An allocator tracks which regions are in use and which are free, returns
a pointer to suitable space when requested, and makes that space available
for reuse when it is freed. In this task, `mmap()` provides one region called
an **arena**, and your allocator manages smaller blocks within it.

A **buddy allocator** manages blocks whose sizes are powers of two. To satisfy
a request, it repeatedly splits a larger free block into two equal halves
until it reaches the required block size. The two halves of each split are
called **buddies**. When both buddies are free, they can merge back into their
original larger block; this merging is called **coalescing** and can repeat.
Adjacent free blocks are not necessarily buddies.

For example, a request for 100 bytes uses a 128-byte block, leaving 28 bytes
unused inside that allocation (**internal fragmentation**). Coalescing helps
recover larger free blocks for future requests. Freeing a block makes it
reusable inside the arena; it does not erase its contents or return that
individual block to the operating system.

Work in `buddy.c` to build a buddy allocator over a 1024-byte arena obtained
with one anonymous `mmap()`. The smallest block is 64 bytes. Allocation splits larger blocks;
freeing merges equal-sized free buddies. No linked lists, trees, threads,
interactive shell, or growing arena are needed.

### Files

| File | Purpose |
| --- | --- |
| `buddy.c` | Complete arena mapping in `main()`, plus `my_malloc()` and `my_free()`. |
| `examples/demo.txt` | Splitting, freeing, repeated coalescing, and whole-arena reuse. |
| `examples/fragmentation.txt` | Adjacent free blocks that cannot merge because they are not buddies. |
| `Makefile` | Builds both tasks; `make demo` runs the allocator example. |

### Build and run

```sh
make buddy
./buddy examples/demo.txt
./buddy examples/fragmentation.txt
make grade         # Run the checks for both tasks
make grade-buddy   # Run only Task 1
```

The skeleton compiles, but exits with a message until the mapping TODO is
completed. Allocations still return `NULL` until `my_malloc()` is implemented.
To compile without Make:

```sh
gcc buddy.c -o buddy
```

Use Linux with GCC, Make, and `timeout`. The Makefile does not select a C
language version; GCC uses its default.

`examples/demo.txt` makes two 100-byte requests (IDs 1 and 2), frees them,
then allocates and frees the entire 1024-byte arena (ID 3). It ends with one
free 1024-byte block. The walkthrough below is a separate, more detailed
example with a third 100-byte allocation.

### Commands

The driver reads a command file from top to bottom:

- `alloc <bytes>` — allocates a block, prints its ID, arena-relative offset, and rounded size. Requests of zero or more than 1024 bytes fail.
- `free <id>` — releases that allocation for reuse.
- `show` — prints every block's offset, size, and FREE/USED state.

### Step-by-step example

The following describes a completed implementation processing the commands
shown below in order, starting with an empty arena. Offsets are bytes from `arena`; metadata
slot indices are offsets divided by 64. Each `show` calls `show_blocks()`,
which prints active blocks, changes nothing, and returns no value. Entries
with `size == 0` are not printed.

**1. `show` before allocating anything**

In `main()`, your `mmap()` returns the arena's starting address on success
(or `MAP_FAILED` on failure). The provided code initializes `blocks[0]` as
one free 1024-byte block. No call to `my_malloc()` has happened yet.

```text
Offset  Size  State
     0  1024  FREE
```

**2. `alloc 100`, then `show`**

- `my_malloc(100)` calls `round_size(100)`, which returns **128**.
- `find_free_block(128)` returns slot **0**, currently a free 1024-byte block.
- Split it into two 512-byte blocks. Keep the left half selected and record
  the free right half at offset 512 (slot 8).
- Split the selected 512-byte block into two 256-byte blocks; the right half
  starts at offset 256 (slot 4).
- Split the selected 256-byte block into two 128-byte blocks; the right half
  starts at offset 128 (slot 2).
- Mark the selected 128-byte block used and return **`arena`**. The driver
  stores this pointer as allocation ID **1**.

```text
alloc 100 -> id 1, offset 0, size 128
Offset  Size  State
     0   128  USED
   128   128  FREE
   256   256  FREE
   512   512  FREE
```

There are four rows: one allocated block and three free blocks.
Each split adds one block to the layout.

**3. `alloc 100` again, then `show`**

- `round_size(100)` again returns **128**.
- `find_free_block(128)` returns slot **2**, the free 128-byte block at offset 128.
- Its size already matches, so the splitting loop does not run.
- Mark it used and return **`arena + 128`**. The driver assigns ID **2**.

```text
alloc 100 -> id 2, offset 128, size 128
Offset  Size  State
     0   128  USED
   128   128  USED
   256   256  FREE
   512   512  FREE
```

There are still four rows: an existing free block was reused without splitting.

**4. A third `alloc 100`, then `show`**

- `round_size(100)` returns **128**, but neither existing 128-byte block is free.
- `find_free_block(128)` returns slot **4**, the free 256-byte block at offset 256.
- Split it once into 128-byte blocks at offsets 256 and 384 (slots 4 and 6).
- Mark the left half used, leave the right half free, and return
  **`arena + 256`**. The driver assigns ID **3**.

```text
alloc 100 -> id 3, offset 256, size 128
Offset  Size  State
     0   128  USED
   128   128  USED
   256   128  USED
   384   128  FREE
   512   512  FREE
```

Now there are **five rows**: splitting one free block into two added one row.

**5. `free 1`, then `show`**

The driver passes ID 1's pointer to `my_free()`. `allocated_index(arena)` returns
slot **0**. Mark it free; its 128-byte buddy at offset 128 is still used, so stop.
`my_free()` returns no value; the driver clears ID 1's stored pointer.

```text
free 1 -> OK
Offset  Size  State
     0   128  FREE
   128   128  USED
   256   128  USED
   384   128  FREE
   512   512  FREE
```

**6. `free 2`, then `show`**

`allocated_index(arena + 128)` returns slot **2**. Mark it free, then merge it
with its free 128-byte buddy at offset 0. Store a free 256-byte block at slot 0
and clear slot 2. Stop: the matching 256-byte region at offset 256 is split into
smaller blocks, including one still used. `my_free()` returns no value.

```text
free 2 -> OK
Offset  Size  State
     0   256  FREE
   256   128  USED
   384   128  FREE
   512   512  FREE
```

**7. `free 3`, then `show`**

`allocated_index(arena + 256)` returns slot **4**. Free it and merge successively:
128-byte buddies at offsets 256 and 384 become 256 bytes; the 256-byte buddies
at offsets 0 and 256 become 512 bytes; the 512-byte buddies at offsets 0 and 512
become 1024 bytes. Clear the redundant right-hand metadata entry at each merge.
`my_free()` returns no value. Only one block remains:

```text
free 3 -> OK
Offset  Size  State
     0  1024  FREE
```

### Functions to complete

- **Mapping in `main()`:** obtain the arena with one `mmap()` call using the
  plain-English hints in the TODO. Keep the provided failure check and final `munmap()`.
- **`my_malloc()`:** split the selected free block to the rounded size, mark it
  used, and return its starting pointer. Return `NULL` if allocation is impossible.
- **`my_free()`:** mark a valid allocation free and repeatedly merge free,
  same-size buddies. Keep the merged block at the lower slot and clear the
  higher slot. It returns no value.

Rounding, selection, and pointer validation are provided. Use the supplied
arena for every allocation; do not call `malloc()`, `sbrk()`, or another `mmap()`
inside the allocator functions. Work out each buddy's position from the
current block's size and offset within the arena.

### Testing Task 1

Running the program on a command file exercises the mapping in `main()`.
The fragmentation example shows why adjacent non-buddies cannot merge.
The checker `check_buddy.c` directly tests the allocator using its own arena;
it does **not** exercise the mapping TODO in your `main()`.

Its eight test groups check:

- Request rounding and rejection of zero or oversized requests.
- Correct splitting and returned offsets inside the arena.
- Selection of the smallest suitable block, with lowest-offset tie-breaking.
- Capacity, reuse of freed space, and preservation of other allocations' data.
- Coalescing regardless of which buddy is freed first.
- Refusing to merge adjacent blocks that are not buddies.
- Recovering the arena after mixed-size allocations are freed out of order.
- Ignoring invalid pointers and double frees before reallocation.

Expect **8/8 checks passed** once the allocator is complete. Failures are normal
while TODOs remain; use the failed check names to guide your debugging.


---

## Task 2: Shared memory and synchronization

Work in `rw.c` to build the writer and reader halves of a file-backed shared
memory channel. Three writer threads write records into a shared mapping of
a file; a reader maps the same file and prints the records back.

A **shared mapping** (`MAP_SHARED`) lets processes map the same file and see
changes to its mapped pages. A write by one process can be seen by another
without calling `read()` or `write()`. Writes through a *private* mapping
(`MAP_PRIVATE`) do not update the file, so they cannot be used to publish
changes to another process through that file.

Running `./rw write` to completion and *then* running `./rw read` shows the
final file contents. To see changes while the writer is still running, run the
writer and reader **at the same time**, in separate terminals — see "Watching
it live" below.

### Files

| File | Purpose |
| --- | --- |
| `rw.c` | Complete the `mmap()` in `run_writers()`, plus `writer_thread()` and `run_reader()`. |

### Build and run

```sh
make rw
./rw write
./rw read
make grade-rw
```

`./rw write` creates `shared.bin`. `./rw read` polls it: if the writer has
already finished, it prints everything instantly; if you run it *while*
`./rw write` is still going, it waits and prints each writer's line as that
writer's data actually becomes visible in shared memory. That's the
difference a shared mapping makes: `./rw read` never needs the writer process
to exit first.

The skeleton compiles, but `./rw write` exits with a message until the
`mmap()` TODO is done, and `./rw read` prints nothing until `run_reader()` is
implemented.

### Watching it live

Once all three TODOs are done, start the writer in one terminal (start this
one first, so the file exists before the reader looks for it):

```sh
RW_DEMO_STAGGER_MS=300 ./rw write
```

`RW_DEMO_STAGGER_MS` just slows the demo down (a 300 ms gap before spawning
each writer thread) so you have time to see it happen; it has no effect on
grading. In a second terminal:

```sh
./rw read
```

You should see each `writer %d: %s` line appear as that writer finishes, not
all at once. Or run both together with:

```sh
make demo-rw
```

### Expected output

Once all three writers have finished (whether `./rw write` already exited, or
you're watching it finish live):

```text
writer 0: hello from writer 0
writer 1: hello from writer 1
writer 2: hello from writer 2
records_written: 3
```

The three writer lines can appear in **any order** — three threads (or, in the
concurrent demo, two separate processes) are racing, so whichever writer
finishes first is whichever line prints first. The counter line is printed
last because it is the one value that isn't final until every record has
arrived. Message text is yours to choose; the grader requires it to be
non-empty.

### Region layout

`SHARED_FILE` is truncated to `REGION_SIZE = (1 + NUM_WRITERS) * RECORD_SIZE`
bytes and divided into `RECORD_SIZE`-byte slots. Slot 0 is the `Header`; its
first four bytes hold `records_written` (`uint32_t`), and the rest of the
slot is unused padding that exists only so the header occupies one full
`RECORD_SIZE`-byte slot like every record does. Slots 1–3 are writer
records: slot `1 + id` belongs to writer `id`. Because each writer always
writes to its own fixed slot regardless of when it finishes, the **final**
record layout is deterministic even though the writers race — only the
timing of when each write becomes visible is not.

`records_written` is the number of writers that have **finished** their
record. It tells the reader *how many* records are complete, not *which* ones
— that is why the reader checks each record's message individually, and why
`records_written == NUM_WRITERS` is the reader's signal that everything is
there.

### What you complete

**1. The `mmap()` in `run_writers()`.** The provided code opens `shared.bin`
and calls `ftruncate()` to set its length to `REGION_SIZE`. (A new file is
0 bytes long, and touching mapped memory past the end of a file crashes the
process, so the file must be grown before it is mapped.) You write the
`mmap()` call that stores the mapping in `region`. In plain English, it must:

- let the OS choose the address;
- map `REGION_SIZE` bytes, starting at the beginning of the file;
- allow both reading and writing;
- be **shared**, so writes reach the file and other processes can see them;
- map the file whose descriptor is `fd`.

Look up the argument order and the flag names in `man 2 mmap`.

**2. `writer_thread()`.** In order:

1. Lock the mutex.
2. Fill in your `Record`: set `writer_id` to `id` and write a non-empty
   message.
3. Only *after* the record is filled in, add 1 to `header->records_written`.
4. Unlock the mutex.
5. Flush the whole region to disk and wait for it to finish (`msync`; see
   `man 2 msync`).

The order in step 3 matters. The reader treats the counter as "that many
records are complete", so the counter must never go up before the data it
promises is in place. The provided code gives you `header` and `record`
pointers so you don't need to write the casts yourself.

`msync` only affects *durability* — whether the write has hit disk — not
*visibility*. Once the write lands in a shared mapping, a concurrently
running `./rw read` can already see it, before `msync` ever runs.

**3. `run_reader()`.** In order:

1. Open `shared.bin` for reading only. If it fails, report the error and
   return.
2. `mmap()` the file. In plain English: let the OS choose the address; map
   `REGION_SIZE` bytes from the beginning of the file; read-only access; a
    **shared** mapping so it can observe updates. You may close
   the descriptor right after mapping.
3. Poll until every writer has finished. The writers race, so records become
   ready in any order. Keep a local count starting at 0 and loop while it is
   below `NUM_WRITERS`. On each pass:
   - first set the count from `records_written`;
   - then scan the records, and for each one not yet printed whose message is
     non-empty, print `writer %d: %s\n` (and `fflush(stdout)`);
   - if the count is still below `NUM_WRITERS`, `usleep()` briefly.
4. Print `records_written: %u\n` using that count, then unmap.

Read the count *before* the scan, not after. A writer could finish between
your scan and your check, and you would stop without printing its line. In
this demo, writers fill their records before incrementing the count, so the
final scan can find all three records. This polling example does not provide
full cross-process synchronization.

If you run `./rw read` before any writer has finished, it keeps waiting, so
press Ctrl-C to stop it. The output format must match the expected output
above.

### Testing Task 2

```sh
make rw
./rw write
./rw read
make grade-rw
```

Compare the reader's output with the example above. The checker `check-rw.c`
runs three test groups:

- **Writer data:** after `run_writers()`, it opens `shared.bin` afresh and
  checks that the header counts three records and that each fixed record
  slot contains its correct writer ID and a non-empty message. Writers can
  finish in any order, so it checks each slot by position, not by arrival
  order. If your `mmap()` in `run_writers()` is not shared, the file stays
  empty and this check fails.
- **Reader output:** the output contains three writer lines with valid IDs
  and non-empty messages, followed by the counter line. The grader runs
  writers to completion first, so your polling loop's first pass should find
  everything ready and return without sleeping — this is Task 2's
  autograder-friendly case; running `./rw read` concurrently with
  `./rw write` by hand is how you confirm the polling/waiting path itself. If
  the writers did not finish, this check fails immediately with a message
  instead of waiting: fix the writer side first.
- **Repeated writes:** writing and checking the file ten times tests repeated
  initialization and may expose counter updates lost through missing locking.

Expect **3/3 checks passed** when complete. If `make grade-rw` stops with a
timeout, your reader is waiting for something that never arrives — check the
loop condition. Passing these checks alone does not prove correct mutex use or
the reader's mapping flags; follow the TODO instructions too. The checker
recreates and removes `shared.bin`, so run `./rw write` again before another
manual read. Use `make grade` to run both tasks' checkers in one command.
