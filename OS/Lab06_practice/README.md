# Lab06 (practice): Free-list allocator and a pool allocator

Run every command in this README from the root directory of the lab.

This is **not** a real BITS lab — I built it as extra practice, in the same
style as Lab05, covering two allocator designs Lab05 didn't: an **embedded
free list with headers** (the other half of the slide deck) and a **fixed-size
pool allocator on `sbrk`** (a different syscall, a different data structure).
If your eval turns out to ask about the buddy allocator instead, go back to
Lab05.

## Task 1: Free-list allocator

Memory allocation means reserving a region of memory for a program to store
data. An allocator tracks which regions are in use and which are free, returns
a pointer to suitable space when requested, and makes that space available
for reuse when it is freed. In this task, `mmap()` provides one region called
a **heap**, and your allocator manages variable-sized chunks within it.

A **free-list allocator** keeps every free chunk's size and a `next` pointer
**embedded inside the free chunk itself** (there is no separate list
structure). Every chunk, free or allocated, has an 8-byte header: `size`
(payload bytes) and `magic` (a marker present only while allocated, used to
recognize valid pointers and reject double frees). To satisfy a request, the
allocator walks the free list looking for a chunk that fits (**first fit**:
the first one big enough); if the chunk is much bigger than needed it is
**split**, leaving a smaller free remainder in the list. When a chunk is
freed, it is reinserted in **address order** and merged (**coalesced**) with
a free neighbour immediately before or after it in memory — this only works
because the list is kept sorted by address, so true neighbours are easy to
find.

For example, three `malloc(100)` calls on a 4088-byte heap each consume
100 + 8 = 108 bytes, leaving 3764 bytes free. Freeing only the *middle* one of
the three leaves two disconnected free chunks (100 and 3764 bytes), so even
though about 3864 bytes are free in total, a 3800-byte request still fails
(**external fragmentation**) until the neighbours are freed too and merge.

Work in `flalloc.c` to build this allocator over a 4096-byte heap (4088 usable
after the first chunk's header) obtained with one anonymous `mmap()`. The
smallest payload is 8 bytes (enough to hold a `next` pointer while free).
Allocation uses first fit and splits when the remainder is usable; freeing
reinserts in address order and merges with both neighbours when possible. No
segregated size classes, thread safety, or growing the heap are needed.

### Files

| File | Purpose |
| --- | --- |
| `flalloc.c` | Complete heap mapping in `main()`, plus `fl_malloc()` and `fl_free()`. |
| `examples/slides.txt` | Reproduces the slide deck's own numbers: 108 bytes/alloc, 3764 free, the 3800-byte failure, then full recovery. |
| `examples/fits.txt` | A case where first fit clearly differs from best/worst fit. |
| `examples/coalesce.txt` | Frees four neighbours in an order designed to exercise both merge directions. |
| `examples/edges.txt` | Boundary sizes: largest request that still splits, smallest remainder, a full heap. |
| `Makefile` | Builds both tasks; `make demo` runs one example from each. |

### Build and run

```sh
make flalloc
./flalloc examples/slides.txt
./flalloc examples/fits.txt
make grade         # Run the checks for both tasks
make grade-flalloc # Run only Task 1
make check-examples # Compare your output against saved expected output
```

The skeleton compiles, but `./flalloc` exits with a message until the mapping
TODO is completed. Allocations still return `NULL` until `fl_malloc()` is
implemented. To compile without Make:

```sh
gcc flalloc.c -o flalloc
```

Use Linux with GCC, Make, and `timeout`. The Makefile does not select a C
language version; GCC uses its default.

`examples/slides.txt` walks through exactly the numbers worked out below. The
other three example files are separate scenarios for you to trace by hand
before checking them against the program.

### Commands

The driver reads a command file from top to bottom:

- `alloc <bytes>` — allocates a chunk, prints its ID, chunk offset (from the
  start of the heap, i.e. where its header begins), and payload size actually
  given. Requests of zero or more than the heap can ever hold fail.
- `free <id>` — releases that allocation for reuse.
- `show` — prints every chunk's offset, payload size, and USED/FREE state (in
  address order, covering the whole heap with no gaps), then the free list in
  list order (which is also address order, once your `fl_free()` is correct).

### Step-by-step example (`examples/slides.txt`)

The following describes a completed implementation processing the commands in
that file, starting with an empty heap. Offsets are bytes from `heap`; a
chunk's header (`HDR`, 8 bytes) sits at its offset, and its payload starts 8
bytes later. `show` calls `show_heap()`, which prints active chunks in
address order, changes nothing, and returns no value.

**1. `show` before allocating anything**

In `main()`, your `mmap()` returns the heap's starting address on success (or
`MAP_FAILED` on failure). The provided code initializes one free chunk
covering the whole 4088-byte payload. No call to `fl_malloc()` has happened
yet.

```text
Offset  Payload  State
     0     4088  FREE
Free list: [0:4088]
```

**2. Three `alloc 100` calls, then `show`**

- Each `fl_malloc(100)` needs 100 payload bytes (above the 8-byte minimum), so
  nothing is rounded up, unlike the buddy allocator.
- `find_first_fit(100)` returns the one free chunk, which is far bigger than
  needed, so it **splits**: the first 100 bytes (plus header) becomes the
  allocation, and the rest becomes a new, smaller free chunk that takes the
  old chunk's place in the list.
- This happens three times in a row, each time splitting off the front of the
  single remaining free chunk.

```text
alloc 100 -> id 1, chunk 0, payload 100
alloc 100 -> id 2, chunk 108, payload 100
alloc 100 -> id 3, chunk 216, payload 100
Offset  Payload  State
     0      100  USED
   108      100  USED
   216      100  USED
   324     3764  FREE
Free list: [324:3764]
```

Three chunks of 108 bytes each (100 payload + 8 header) were carved from the
front, leaving 4088 − 324 = 3764 bytes free — matching the slide.

**3. `free 2`, then `show`**

`fl_free()` on ID 2's pointer locates its chunk at offset 108. It is inserted
into the free list in address order: after the (nonexistent) chunk before it
and before the 3764-byte chunk at offset 324. Its neighbours (chunk 0, still
used; chunk 216, still used) are not free, so nothing merges.

```text
free 2 -> OK
Offset  Payload  State
     0      100  USED
   108      100  FREE
   216      100  USED
   324     3764  FREE
Free list: [108:100] [324:3764]
```

**4. `alloc 3800`, then `free 1`, then `show`**

The request for 3800 payload bytes fails: the only free chunks are 100 and
3764 bytes, and neither is big enough on its own — this is external
fragmentation, even though 3864 bytes are free in total. Freeing ID 1 (offset
0) then merges with its free neighbour at offset 108, since they are
adjacent in memory: chunk 0's end (0 + 8 + 100 = 108) is exactly where the
freed chunk starts.

```text
alloc 3800 -> FAILED
free 1 -> OK
Offset  Payload  State
     0      208  FREE
   216      100  USED
   324     3764  FREE
Free list: [0:208] [324:3764]
```

The merged chunk holds 100 + 8 + 100 = 208 payload bytes (its own 100, its
neighbour's 8-byte header, and the neighbour's 100).

**5. `free 3`, then `show`**

Freeing ID 3 (offset 216) merges with both neighbours at once: the free chunk
before it at offset 0 (which ends exactly at 216) and the free chunk after it
at offset 324 (which starts exactly where this chunk ends, 216 + 8 + 100 =
324).

```text
free 3 -> OK
Offset  Payload  State
     0     4088  FREE
Free list: [0:4088]
```

Everything is one chunk again, exactly as at the start.

### Functions to complete

- **Mapping in `main()`:** obtain the heap with one `mmap()` call using the
  plain-English hints in the TODO. Keep the provided failure check and final
  `munmap()`.
- **`fl_malloc()`:** find the first free chunk that fits (already provided,
  and selectable for best/worst fit if you want to experiment — see below),
  split it if there's a usable remainder, unlink it from the free list, mark
  it allocated, and return a pointer to its payload.
- **`fl_free()`:** mark the chunk free, reinsert it into the free list in
  address order, then merge with the chunk immediately following it and the
  chunk immediately preceding it, whichever are actually adjacent in memory
  and free.

Chunk validation (`chunk_from_ptr`), the payload/header math (`HDR`), and the
list traversal helper (`find_first_fit`) are provided. Use the supplied heap
for every allocation; do not call `malloc()`, `sbrk()`, or another `mmap()`
inside the allocator functions.

*(Optional, not graded: `find_first_fit` is written so that changing the
`FIT` macro at the top — `0` = first, `1` = best, `2` = worst — changes the
selection policy without touching your `fl_malloc()`. `examples/fits.txt`
is designed so all three policies give different results; try
`gcc -DFIT=1 flalloc.c -o flalloc-best` and compare.)*

### Testing Task 1

Running the program on a command file exercises the mapping in `main()`. The
example files above show the numbers to expect. The checker `check_flalloc.c`
directly tests the allocator using its own heap; it does **not** exercise the
mapping TODO in your `main()`.

Its eight test groups check:

- Request limits and the 8-byte minimum payload.
- The slide's own numbers: 108 bytes per 100-byte request, 3764 remaining,
  the 3800-byte request that fails, then recovery once neighbours are freed.
- The split threshold (when a remainder is kept vs. when the whole chunk is
  handed over) at both sides of the boundary.
- First fit choosing the earliest suitable chunk, not the smallest.
- Coalescing regardless of which of three neighbours is freed first (all six
  orders).
- Merging with both neighbours in a single free.
- Ignoring invalid pointers and double frees before reallocation.
- A long random sequence of allocations and frees, checking data survives and
  the heap tiles with no gaps or adjacent free chunks after every operation.

Expect **8/8 checks passed** once the allocator is complete. Failures are
normal while TODOs remain; use the failed check names to guide your
debugging.

---

## Task 2: Pool allocator (fixed-size slots, `sbrk`)

A **pool allocator** (also called a slab or fixed-size allocator) only ever
hands out chunks of *one* fixed size. Because every slot is identical, there's
no rounding, no splitting, and no coalescing to worry about — the entire
allocator is just a free list threaded through the unused slots themselves,
exactly like Task 1's embedded list but simpler, since a slot's size is
always known in advance and never changes.

Work in `pool.c` to build a pool of 16 slots of 32 bytes each, obtained with
one `sbrk()` call (not `mmap()` — this task also gives you practice with the
other memory syscall from the slides). A free slot's first bytes hold a
pointer to the next free slot (or `NULL`); `pool_alloc()` pops the front of
that list, and `pool_free()` pushes a freed slot back onto the front (so the
most recently freed slot is the next one handed out — **LIFO** reuse, unlike
Task 1's address-ordered list).

### Files

| File | Purpose |
| --- | --- |
| `pool.c` | Complete the `sbrk()` in `main()`, plus `pool_init()`, `pool_alloc()`, and `pool_free()`. |
| `examples/pool_demo.txt` | Allocate, free, and reallocate a few slots to see LIFO reuse. |
| `examples/pool_full.txt` | Fill the pool completely, confirm it rejects further requests, then free and refill. |

### Build and run

```sh
make pool
./pool examples/pool_demo.txt
./pool examples/pool_full.txt
make grade-pool
```

The skeleton compiles, but `./pool` exits with a message until the `sbrk()`
TODO is done, and every allocation fails until `pool_init()` and
`pool_alloc()` are implemented. To compile without Make:

```sh
gcc pool.c -o pool
```

### Commands

- `alloc` — takes no argument (every slot is the same size). Prints the new
  ID and which slot it landed in. Fails once every slot is in use.
- `free <id>` — releases that allocation for reuse.
- `show` — prints a 16-character map (`U`/`F` per slot, in slot order) and the
  free list in list order, plus a used/free count.

### Step-by-step example (`examples/pool_demo.txt`)

Starting with an empty pool, slots are threaded 0 → 1 → ... → 15 → `NULL`.

**1. `show` before allocating anything**

```text
Slots: FFFFFFFFFFFFFFFF
Free list: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
Used: 0  Free: 16
```

**2. Three `alloc` calls, then `show`**

Each `pool_alloc()` pops the front of the free list, so the first three
allocations land in slots 0, 1, 2 in order.

```text
alloc -> id 1, slot 0
alloc -> id 2, slot 1
alloc -> id 3, slot 2
Slots: UUUFFFFFFFFFFFFF
Free list: 3 4 5 6 7 8 9 10 11 12 13 14 15
Used: 3  Free: 13
```

**3. `free 2`, then `show`**

Slot 1 (ID 2) goes back to the **front** of the free list.

```text
free 2 -> OK
Slots: UFUFFFFFFFFFFFFF
Free list: 1 3 4 5 6 7 8 9 10 11 12 13 14 15
Used: 2  Free: 14
```

**4. `alloc`, then `show`**

The next `pool_alloc()` takes slot 1 straight back — the most recently freed
slot is reused first (LIFO), not the least recently freed.

```text
alloc -> id 4, slot 1
Slots: UUUFFFFFFFFFFFFF
Free list: 3 4 5 6 7 8 9 10 11 12 13 14 15
Used: 3  Free: 13
```

**5. `free 1`, `free 3`, then `show`**

Freeing ID 1 (slot 0) pushes slot 0 to the front. Freeing ID 3 (slot 2) then
pushes slot 2 in front of *that* — so the free list is now 2, then 0, then
the untouched tail.

```text
free 1 -> OK
free 3 -> OK
Slots: FUFFFFFFFFFFFFFF
Free list: 2 0 3 4 5 6 7 8 9 10 11 12 13 14 15
Used: 1  Free: 15
```

**6. Two more `alloc` calls, then `show`**

They take slot 2, then slot 0 — in exactly the order the last two frees
pushed them on.

```text
alloc -> id 5, slot 2
alloc -> id 6, slot 0
Slots: UUUFFFFFFFFFFFFF
Free list: 3 4 5 6 7 8 9 10 11 12 13 14 15
Used: 3  Free: 13
```

Notice this is the same final state as after step 2 — the pool has no memory
of *which* allocation ID used a slot, only which slots are free.

### Functions to complete

- **The `sbrk()` in `main()`:** grow the program break by `POOL_BYTES` and
  store the result in `pool`. Remember: `sbrk()` returns the **old** break —
  which is exactly the start of the memory you just got — and `(void *)-1` on
  failure (there is no `MAP_FAILED` involved here).
- **`pool_init()`:** thread every slot to the next one in order, ending in
  `NULL`, and point `free_head` at slot 0. Nothing is marked used.
- **`pool_alloc()`:** pop the front of the free list, mark that slot used,
  and return it. Return `NULL` if the pool is full.
- **`pool_free()`:** validate the pointer (exactly the start of a slot inside
  the pool, currently marked used — ignore anything else, including double
  frees), mark it free, and push it onto the **front** of the free list.

`slot_index()`, `get_next()`/`set_next()`, and the command-file driver are
provided. Use the supplied pool for every allocation; do not call `malloc()`
or `mmap()` inside the allocator functions.

### Testing Task 2

```sh
make pool
./pool examples/pool_demo.txt
./pool examples/pool_full.txt
make grade-pool
```

Compare the program's output with the walkthrough above. The checker
`check_pool.c` runs six test groups:

- The initial free list order and empty used[] array.
- Filling every slot, then confirming further allocation fails (repeatedly).
- LIFO reuse: a freed slot is the very next one handed out.
- Slot data staying isolated — freeing one slot must not disturb another
  slot's contents.
- Invalid pointers (NULL, outside the pool, mid-slot, in-range but never
  allocated) and double frees, all ignored, with allocation continuing
  correctly afterward.
- A long random sequence of allocations and frees, checking the free list
  stays consistent (no slot listed twice, no used slot on the list, no
  cycles) throughout.

Expect **6/6 checks passed** when complete. Passing these checks alone does
not prove you used `sbrk()` correctly or that `pool_free()` rejects every bad
input the checker didn't think to try; follow the TODO instructions too. Use
`make grade` to run both tasks' checkers in one command, and
`make check-examples` to diff your program's actual output against the saved
expected output for every example file (including the optional
best-fit/worst-fit variants for Task 1, if you tried them).
