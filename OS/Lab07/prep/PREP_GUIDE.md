# OS Eval Lab Prep: Demand Paging (Lab 7)

Everything here was checked against the practice lab. The reference solution passes **14/14**, and every variant in `variants/` compiles and was traced against a simulator.

| File | What it is |
|---|---|
| `prep/paging_solution.c` | Full practice solution (14/14). To check: `cp prep/paging_solution.c paging.c && make test` (back up your own `paging.c` first) |
| `prep/variants/A…G` | Likely eval policies. Each file contains only the functions that change |
| `paging.c` | Still the **untouched template**. Practise writing it from scratch |

---

## 0. TL;DR: what the eval will most likely be

The prof said the eval uses the same template and format with a different policy. So expect:

- The same files: `sim_framework.c`, `paging_sim.h`, `paging_test_driver.c`, `grader.py`, `public/tests`, `make test`.
- The same three functions (`select_victim_page`, `evict_page`, `load_page`). The real change will be in `select_victim_page`, perhaps with a small twist in `evict_page` or `load_page`.
- **You will probably have to edit the simulator yourself.** The prof's message said "go over the simulator code… you might need to add 3-4 lines". The new policy will likely need metadata the simulator doesn't track yet (a reference bit, load time, or access count), and you'll add it. See **§8**.
- Output is compared **byte-for-byte**. Every simulator API call prints a line, so **the order and number of your API calls is your output.**

**Exam workflow (60 min):**
1. Spend 5 min reading the README's policy section. Note the bucket order, the in-bucket key (LRU/FIFO/MRU/LFU), the **tie-break rule**, and when to return `-1`.
2. Spend 3 min diffing `paging_sim.h` and `sim_framework.c` against the practice versions. Look for new fields, new APIs, and changes to `sim_mark_page_loaded` (does it still reset `swap_slot` to -1?).
3. Write `evict_page` and `load_page` first. They are usually identical to the practice lab and earn easy tests. Run `make test N="4 5 6 7"` style subsets.
4. Write `select_victim_page` using the **rank + key** template (§4).
5. When a test fails, read the **unified diff**. The first differing line tells you which decision was wrong.

---

## 1. Theory you need (from the slides, exam-relevant)

**Demand paging.** A page is brought into RAM only when it is accessed. The OS overcommits memory, so the virtual memory in use can exceed physical memory.

**PTE bits.**
- **Valid** means the page is in use by the process. **Present** means it is in a RAM frame.
- Valid and present: the page is in DRAM.
- Valid but not present: the page is in swap or the file. This is the case the page fault handler resolves.
- Invalid: segfault, and the process is killed. Illegal access (for example a write to a read-only page) also kills the process.
- In the lab, `resident` plays the role of the present bit. `frame_id`, `swap_slot`, and `file_id`/`file_offset` say where the page lives.

**Page fault flow (slide 17).** TLB miss → page table walk → PTE not present → trap to the OS → **swap out a victim (if needed)** → **swap in the page (if needed)** → update the PTE → restart the instruction. In the lab, `read_virtual_memory`/`write_virtual_memory` play the MMU, `handle_page_fault` is the handler, and your three functions are the policy and I/O steps.

**Two kinds of pages.**
- **File-backed** (code, mmapped files): the file is the authoritative copy.
  - Clean: just drop it.
  - Dirty: write it back to the file first.
- **Anonymous** (heap, stack): no file holds its contents, so on eviction it must go to **swap**.
  - First touch: **zero-fill** with no I/O. This is a **minor fault**.

**Minor vs major fault (README + slide 25, `getrusage` `ru_minflt`/`ru_majflt`).**
- Minor: resolved without disk I/O (zero-fill, or a page already in memory).
- Major: needs disk I/O (swap-in, file read).

**Dirty bit.** The page was modified since it was loaded, so the disk copy is stale. The slides note that a clean page can sometimes be dropped. **The lab deliberately says a clean anon page must still be swapped**, because the simulator clears the dirty bit and frees the swap slot on load, so no valid copy exists anywhere else. Know both views and why they differ (§3 G2 "swap cache").

**When eviction really happens.** The OS does not wait for memory to fill. Watermarks decide:
- Below the **high watermark**, the swap daemon starts reclaiming in the background.
- Below the **low watermark**, it reclaims aggressively.

**Replacement policies (slides 19–23).**
- **Optimal (Belady):** evict the page whose next use is furthest in the future. It cannot be implemented, so it serves as a benchmark.
- **FIFO:** evict the page loaded first. It suffers from **Belady's anomaly**: more frames can give more faults.
- **LRU:** evict the page least recently *used*. It relies on temporal locality. It is expensive because every access must update metadata, and finding the minimum is O(n).
- **LFU:** evict the page used least often. Hot pages are the frequently used ones.
- **Approximate LRU / Clock:** the MMU sets an *accessed* bit on each access.
  - A bit of 1 means clear it and move on (second chance).
  - A bit of 0 means evict that page.
- **Enhanced:** prefer pages that are *unused and clean*, then *unused and dirty*. That is exactly a bucket policy (variant F).

**Other theory.**
- **Thrashing:** the working set is larger than the frames allocated, so the system spends its time paging. Fixes: shrink working sets, kill processes, or add memory.
- **Prefetching:** on a fault for page P, also bring in P+1 (spatial locality).
- **Swap partition vs swap file:**
  - A partition is contiguous and fixed-size, with simple offset math.
  - A file lives inside the filesystem, may not be contiguous, and can be resized.

**Hit-rate maths (slides 20–21).** hit rate = hits / (hits + misses). "Modulo compulsory misses" means the first access to each page is not counted as a miss. Example: optimal with 3 frames on an 11-access stream gives 6/11 = 54.5%, and 6/7 = 85% ignoring cold misses.

---

## 2. Anatomy of the practice lab

```
grader.py ──gcc──> .build/paging_lab = paging_test_driver.c + paging.c + sim_framework.c
                     │ for each public/tests/NN.txt: run, diff stdout vs public/solutions/NN.json
```

**Test-file commands (`paging_test_driver.c`):**

| Command | What it does | Clock ticks? |
|---|---|---|
| `READ p off` / `WRITE p off v` | Full VM access. Faults through `handle_page_fault` if the page is not resident. `WRITE` sets dirty **after** the fault | **yes, +1** before the fault |
| `LOAD p f` | Calls your `load_page(p,f)` directly | **no** (so many pages can share `last=0`, which tests tie-breaks) |
| `EVICT p` | Calls your `evict_page(p)` directly | no |
| `SELECT` | Prints `select_victim_page()`. **For Clock, this has side effects (moves the hand, clears bits)** | no |
| `FAULT p` | Calls `handle_page_fault(p)` directly | no |
| `INFO p` / `STATE` | Prints metadata | no |

**Machine:** 4 frames, 12 pages. Pages 0–5 are ANON and pages 6–11 are FILE (`file_id 101`, `offset = (p-6)*64`). There are 16 swap slots. `sim_alloc_swap_slot()` returns the **lowest free slot**, which is deterministic, and slot numbers appear in the output.

**What the provided `handle_page_fault` does (be ready to write it yourself):**
1. Find the lowest frame not owned by any resident page.
2. If there is none: `victim = select_victim_page()`, then **record `frame = info(victim).frame_id` BEFORE `evict_page`**, because evicting sets the page's frame to -1. Then call `evict_page(victim)`.
3. Call `load_page(page, frame)`.

**Who prints what:**
- `sim_read/write_to_swap` print `[DISK I/O] SWAP IN/OUT`.
- `sim_read/write_to_file` print `[FILE I/O]`.
- `sim_zero_fill_frame` prints `[MEM] ZERO-FILL`.
- `sim_alloc/free_swap_slot`, `sim_set_swap_slot`, and `sim_mark_*` print **nothing**. Their effects only show up later, through slot numbers and `INFO`.

---

## 3. The practice solution and the learnings

```c
int select_victim_page(void) {
    int best = -1, best_cat = 5; uint64_t best_time = 0;
    for (int p = 0; p < sim_page_count(); p++) {
        PageInfo info = sim_get_page_info(p);
        if (!info.resident) continue;
        int cat = (info.type == PAGE_ANON && !info.dirty) ? 1
                : (info.type == PAGE_FILE && !info.dirty) ? 2
                : (info.type == PAGE_ANON)                ? 3 : 4;
        if (cat < best_cat || (cat == best_cat && info.last_access_time < best_time)) {
            best = p; best_cat = cat; best_time = info.last_access_time;
        }
    }
    return best;                       // -1 iff nothing resident
}

void evict_page(int v) {
    PageInfo info = sim_get_page_info(v);
    if (info.type == PAGE_ANON) {                 // ALWAYS to swap, clean or dirty
        int slot = info.swap_slot;
        if (slot == -1) slot = sim_alloc_swap_slot();
        sim_write_to_swap(info.frame_id, slot);
        sim_set_swap_slot(v, slot);
    } else if (info.dirty) {                      // file: write back only if dirty
        sim_write_to_file(info.frame_id, info.file_id, info.file_offset);
    }
    sim_mark_page_evicted(v);                     // LAST: after the data is safe
}

void load_page(int p, int f) {
    PageInfo info = sim_get_page_info(p);
    if (info.type == PAGE_ANON) {
        if (info.swap_slot != -1) {               // was evicted before -> major fault
            sim_read_from_swap(f, info.swap_slot);
            sim_free_swap_slot(info.swap_slot);
        } else sim_zero_fill_frame(f);            // first touch -> minor fault
    } else sim_read_from_file(f, info.file_id, info.file_offset);
    sim_mark_page_loaded(p, f);                   // LAST: after the frame is filled
}
```

### Key learnings (the non-obvious ones)

1. **`sim_get_page_info` returns a copy (a snapshot).** After you call `sim_set_swap_slot`/`sim_mark_*`, your local `info` is stale. Re-fetch it if you need fresh values. The snapshot is also why "read info first, then act" is safe.
2. **The tie-break comes free from a strict `<` plus an ascending scan.** The first (smallest) `page_id` is kept on a tie. With `<=`, test 3 fails, because `LOAD` does not tick the clock and pages share `last=0`.
3. **Priority beats recency across buckets.** A cat-1 page with timestamp 100 is evicted before a cat-2 page with timestamp 1. Pure LRU fails tests 2, 9, 10, and 12.
4. **Clean anon pages are still swapped.** `dirty == false` does not mean a copy exists elsewhere, because `sim_mark_page_loaded` resets `swap_slot = -1`.
5. **Free the swap slot in `load_page`. It is your only chance.** `sim_mark_page_loaded` overwrites `swap_slot` with -1, so if you don't free the slot first, it leaks forever. Slot numbers then shift in later output, and tests 5, 12, and 14 fail.
6. **Order of operations:** do the I/O first, then `sim_mark_*`. In `evict_page`, use `info.frame_id`; it is valid because you read it before `mark_evicted`.
7. **Return `-1` only when nothing is resident.** The handler does not check for -1, so never return it while frames are full.
8. **`WRITE` sets dirty after the fault.** A page that faults in because of a `WRITE` is dirty immediately after.
9. **The timestamp of a loaded page equals the current clock.** `mark_page_loaded` sets `last = global_clock`, and the access then sets it again to the same value.
10. Static variables in `paging.c` are fine for extra policy state (FIFO order, clock hand). Every test runs in a **fresh process**.

### Which tests catch which mistake (verified by mutating the solution)

| Mistake | Tests that fail |
|---|---|
| Not freeing the swap slot on swap-in | 5, 12, 14 (11/14) |
| Only swapping **dirty** anon pages | 2, 3, 5, 8, 12 (9/14) |
| `<=` instead of `<` (tie-break wrong) | 3 |
| Writing back clean file pages | 7 |
| Pure LRU, ignoring buckets | 2, 9, 10, 12 |
| `mark_loaded` before filling the frame / freeing the slot before reading | **none**. Output is identical, but it is still wrong per the spec, and hidden tests or a viva may probe it |

---

## 4. Universal template for ANY victim policy

Every policy the eval might ask for is: *filter resident pages → choose the minimum by (rank, key, page_id)*. Write it once and change only `rank()` and the key.

```c
/* true if a should be evicted before b; edit ONLY this function */
static bool better_victim(PageInfo a, PageInfo b) {
    int ra = rank(a), rb = rank(b);
    if (ra != rb) return ra < rb;                                   // bucket
    if (a.last_access_time != b.last_access_time)
        return a.last_access_time < b.last_access_time;             // LRU (> for MRU)
    return a.page_id < b.page_id;                                   // tie-break
}

int select_victim_page(void) {
    int best = -1; PageInfo best_info;
    for (int p = 0; p < sim_page_count(); p++) {
        PageInfo info = sim_get_page_info(p);
        if (!info.resident) continue;
        if (best == -1 || better_victim(info, best_info)) { best = p; best_info = info; }
    }
    return best;
}
```

Writing the tie-break explicitly (`a.page_id < b.page_id`) means you never depend on scan direction. If the spec says *larger* `page_id` wins ties, flip that one line.

---

## 5. Likely eval questions, most likely first

| # | Possible eval twist | What changes | File |
|---|---|---|---|
| A | **Different bucket order** (for example file before anon: FC, AC, FD, AD) or different buckets (type only, dirty only) | `rank()` only | `variants/A_reordered_categories.c` |
| B | **FIFO** (globally or within buckets) | key = load order. Use `load_time` if provided, else a static `loaded_at[]` set in `load_page` | `variants/B_fifo.c` |
| C | **MRU** within buckets | `<` becomes `>` on time; keep the tie rule | `variants/C_mru.c` |
| D | **LFU** (+ LRU tie-break) | needs an `access_count` field from the framework | `variants/D_lfu.c` |
| E | **Clock / second chance** | static hand over frames, reference bit, at most 2 sweeps | `variants/E_clock_second_chance.c` |
| F | **NRU / enhanced second chance**: (ref, dirty) classes | `rank = 2*ref + dirty` | `variants/F_nru.c` |
| G | **Mechanism twists**: minor/major fault counters; "swap cache" (keep a clean anon page's slot and skip the rewrite) | `evict_page` / `load_page` | `variants/G_fault_stats_and_swap_cache.c` |

### Pitfalls per variant

- **FIFO:** `last_access_time` is *not* load time, because every READ/WRITE bumps it. Set the static counter in `load_page`, which both `FAULT` and `LOAD` go through. `SELECT`/`EVICT` must not touch it.
- **Clock:** It walks **frames**, not pages. Map frame → page by scanning pages for `frame_id == f`. The hand normally moves to **one past the victim**; check the spec. `SELECT` in a test moves the hand, so a later `FAULT` picks a different page. That is expected.
- **LFU:** Your code cannot count hits, because READ/WRITE on a resident page never call into `paging.c`. If the framework doesn't give you a counter, it isn't LFU-able. Ask.
- **Swap cache:** It only works if the eval's `sim_mark_page_loaded` stops resetting `swap_slot`. With the practice framework, not freeing the slot leaks it, and tests 5, 12, and 14 fail (verified). **Read the framework first.**

### Less likely, but sketch them in your head

- **Write `handle_page_fault` yourself:**
  - Lowest free frame, else select a victim.
  - **Save its frame before `evict_page`.**
  - Then `load_page`.
- **Prefetching (slide 18):** after loading page P, if P+1 exists, is the same type (or any type, per the spec), is non-resident, **and a free frame exists**, also `load_page(P+1, free_frame)`. Do not evict for a prefetch unless the spec says so.
- **Watermarks:** after servicing a fault, `while (free_frames < LOW) evict_page(select_victim_page());`. Count free frames the same way the handler finds one.
- **Per-type quota / local replacement** (for example "file pages may use at most 2 frames"): when a FILE page faults and 2 file pages are resident, the victim must be the best **file** page. Put a type filter in the scan.
- **Optimal/Belady:** only possible if the framework exposes the future reference string (for example `sim_next_use(p)`). The key is the next-use time, **largest wins**, and "never used again" counts as infinity.

---

## 6. Practice questions with answers (answers generated by the real simulator)

**Q1. Practice policy (buckets + LRU). Trace it by hand:**
```
WRITE 0 0 1 | READ 6 0 | WRITE 7 0 2 | READ 1 0 | READ 8 0 | WRITE 6 0 3 | READ 2 0 | READ 1 0 | READ 9 0
```
Which page is evicted at each fault, and what I/O is printed? What are `swap` for pages 1 and 2 at the end?

<details><summary>Answer</summary>

- t1–t4: page 0 → F0 (zero-fill, dirty), page 6 → F1 (file read), page 7 → F2 (file read, dirty), page 1 → F3 (zero-fill, clean).
- `READ 8` (t5): buckets are p1 = AC, p6 = FC, p0 = AD, p7 = FD. Victim **p1** → `SWAP OUT: Frame 3 -> Swap Slot 0`, then p8 is read into F3.
- `WRITE 6` makes p6 dirty.
- `READ 2` (t7): the only clean page is p8 (FC). Victim **p8**, discarded with no write-back. p2 is zero-filled into F3.
- `READ 1` (t8): victim **p2** (AC) → `SWAP OUT: Frame 3 -> Swap Slot 1` (slot 0 is still held by p1), then `SWAP IN: Slot 0 -> Frame 3` and slot 0 is freed.
- `READ 9` (t9): victim **p1** (AC) → `SWAP OUT: Frame 3 -> Swap Slot 0` (the freed slot is reused).
- Final state: page 1 `swap=0`, page 2 `swap=1`.
- **Lesson:** p0 (dirty anon) is the *oldest* page but is never evicted. Frame 3 churns. Bucket priority can starve LRU.
</details>

**Q2. Same trace, three policies.** All anon pages, 4 frames:
```
READ 0 0 | READ 1 0 | READ 2 0 | READ 3 0 | READ 0 0 | READ 4 0 | READ 1 0 | READ 5 0
```
How many faults with LRU, FIFO, and MRU, and which frames are swapped out?

<details><summary>Answer</summary>

- **LRU:** 7 faults.
  - `READ 4` evicts p1 (F1).
  - `READ 1` faults and evicts p2 (F2).
  - `READ 5` evicts p3 (F3), into slot 0, which was reused after p1's swap-in.
- **FIFO:** 6 faults.
  - `READ 4` evicts p0 (F0), the first page loaded, even though it was just used.
  - `READ 1` is a hit.
  - `READ 5` evicts p1 (F1).
- **MRU:** 6 faults.
  - `READ 4` evicts p0 (most recent, t5).
  - `READ 1` is a hit.
  - `READ 5` evicts p1 (t7).
- **Lesson:** LRU is not always best on a given trace.
</details>

**Q3. Belady's anomaly.** FIFO on `1 2 3 4 1 2 5 1 2 3 4 5` with 3 frames and then 4 frames.
<details><summary>Answer</summary>3 frames give 9 faults. 4 frames give 10 faults. Adding memory made FIFO worse. LRU and Optimal are stack algorithms and never show this anomaly.</details>

**Q4. Viva-style short answers.**
1. *Why must a clean anonymous page still be written to swap in this lab?* On load, the simulator freed its swap slot and reset `swap_slot`, so RAM holds the only copy. Clean only means "not modified since load".
2. *Why can a clean file-backed page be dropped?* The file still holds identical bytes, so it can be re-read later.
3. *Which loads are minor faults and which are major?* Zero-fill is minor. Swap-in and file read are major.
4. *Why does `handle_page_fault` read the victim's `frame_id` before calling `evict_page`?* `sim_mark_page_evicted` sets it to -1.
5. *Why rank clean pages before dirty ones?* Evicting a dirty page costs an extra disk write (slide 23).
6. *Valid=1, present=0: what happens?* The OS services the fault (gets a frame, swaps in, updates the PTE, restarts the instruction).
7. *Valid=0?* Segfault, and the process is terminated.
8. *Why approximate LRU instead of exact LRU?* The OS doesn't see every access, and per-access bookkeeping plus a min-search is too expensive. Hardware accessed bits plus Clock are cheap.

---

## 7. Practice routine before the eval

1. **From a blank `paging.c`**, write all three functions in 15 minutes or less without looking, then `make test`.
2. Rewrite `select_victim_page` with the `better_victim()` template (§4). Then turn it into variants A, B, C, and F, each in 2 minutes or less.
3. Write `handle_page_fault` from memory.
4. Make your own test: write `mytest.txt` with READ/WRITE/SELECT/STATE lines, then run it:
   ```bash
   make test N=1
   ```
   ```bash
   ./.build/paging_lab mytest.txt
   ```
   Predict the output by hand before running. That is the skill the eval tests.
5. Do §8 once on a copy of the practice lab: add `referenced` yourself, then run `variants/E_clock_second_chance.c` on it.

---

## 8. Adding metadata to the simulator (the "3-4 lines")

**Why policy code alone can't do it:** `paging.c` only runs on a **fault**. A READ or WRITE to a page that is already in memory goes straight through `read/write_virtual_memory` in `sim_framework.c` and never calls your code. So anything that must notice *every access* (reference bit, access count) has to be recorded inside the simulator.

The same applies to anything about pages that `PageInfo` doesn't expose. `InternalPage` is private to `sim_framework.c`, and `sim_get_page_info` returns a copy.

A worked example that adds `load_time`, `access_count` and `referenced` plus `sim_clear_referenced()` is in `prep/framework_extended/`. See `framework_changes.diff` there. The practice solution still passes 14/14 on it.

### The checklist for adding one field (memorise this)

| # | Where | What |
|---|---|---|
| 1 | `sim_framework.c` → `InternalPage` | `bool referenced;` (the real storage) |
| 2 | `paging_sim.h` → `PageInfo` | `bool referenced;` (what your policy sees) |
| 3 | `sim_framework.c` → `sim_get_page_info` | `.referenced = p->referenced,` (copy it out) |
| 4 | where it changes | on every access, in **both** `read_virtual_memory` and `write_virtual_memory`, after the fault is handled; on load, in `sim_mark_page_loaded`; maybe on evict, in `sim_mark_page_evicted` |
| 5 | (if the policy must change it) new API | definition in `sim_framework.c` + **declaration in `paging_sim.h`** |

### Which events each likely policy needs

| Policy | Field | Set / update where |
|---|---|---|
| FIFO | `load_time` | `sim_mark_page_loaded`: `p->load_time = sys.global_clock;` |
| LFU | `access_count` | `=0` in `sim_mark_page_loaded`; `++` in read **and** write |
| Clock / NRU | `referenced` | `=true` in read, write, and (usually) `sim_mark_page_loaded`; plus a `sim_clear_referenced(page_id)` API |
| Clock (helper) | (none) | `int sim_frame_owner(int f) { return sys.frames[f].mapped_page_id; }` replaces the page scan |
| Swap cache | (none) | **delete** `p->swap_slot = -1;` from `sim_mark_page_loaded` so the slot survives a load |
| Fault stats | `minor_faults` / `major_faults` globals | `++` in `sim_zero_fill_frame` (minor), `sim_read_from_swap` / `sim_read_from_file` (major) |

### Gotchas

- **If you forget step 3, nothing warns you.** `sim_get_page_info` uses a designated initializer (`.field = ...`), and C silently zero-fills any field you leave out. Your policy then sees `referenced == 0` everywhere and quietly picks wrong victims.
- **Hits only show up in `read/write_virtual_memory`.** Updating counters in `load_page` or `handle_page_fault` only counts faults.
- **Order inside `read/write_virtual_memory`:** `global_clock++`, then the fault (if any), then the access update. So a page that faulted in has `access_count == 1` after its first access, while a page placed by the test `LOAD` command has 0, because `LOAD` is not an access.
- **`sim_init` memsets everything to 0.** That is fine for counters and flags. A field that must start at `-1` has to be set in `sim_init`'s per-page loop.
- **Declare new APIs in `paging_sim.h`.** On macOS `gcc` (which is clang), calling an undeclared function in C99 is a compile **error**.
- **Read the eval spec for the edge cases:** does loading set `referenced`? Does eviction reset the count? Does `WRITE` count as a reference? Each choice changes the expected output.
- The grader and `make` compile `sim_framework.c` from the lab folder, so your edits are picked up. The test driver only prints the fields it already knows about, unless the prof changes it.
