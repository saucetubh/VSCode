# Lab: Demand Paging & Priority-Based Eviction

**Suggested time:** 60 minutes

## 1. What are you implementing?

In this lab, you will implement the **policy part of a demand-paging system**.

The simulator already provides the low-level machinery that a real operating system would need: physical frames, a simulated swap area, a simulated file backing store, page metadata, and the mechanism that detects a page fault.

Your job is to implement only the parts that decide **what to evict, how to evict it, and how to bring a page back into memory**.

You do **not** need to:

- implement a real page table,
- allocate physical memory yourself,
- use `mmap`,
- manipulate actual files or disks,
- implement the virtual-memory access mechanism,
- implement the page-fault dispatcher.

Think of the lab as implementing the middle of this flow:

```text
Virtual memory access
        |
        v
   Page fault occurs
        |
        v
+-----------------------+
| Find a free frame     |
| or choose a victim    |  <-- your code participates here
+-----------------------+
        |
        v
   Evict old page       <-- your code
        |
        v
   Load new page        <-- your code
        |
        v
  Resume memory access
```

The provided page-fault handler takes care of the overall orchestration. You only implement the policy and backing-store operations described below.

---

## 2. Paging model

The simulator contains:

- **4 physical frames**
- **12 virtual pages**
- **Pages 0-5:** anonymous pages
- **Pages 6-11:** file-backed pages
- a simulated **swap area** for anonymous pages
- a simulated **file backing store** for file-backed pages

A page is either **resident** in physical memory or **non-resident**.

When loading a page, a Minor fault, occurs when loading a page can be resolved without disk I/O, such as by zero-filling a new anonymous page or mapping a page already available in memory, whereas, a major fault occurs when loading a page requires disk I/O to retrieve its contents from swap space or the backing file.

### Anonymous pages

Anonymous pages do not have an underlying file containing their current contents. If an anonymous page is evicted, its contents therefore have to be preserved somewhere. In this simulator, that place is **swap space**.

A newly created anonymous page has no swap slot yet. On its first access, it is simply zero-filled. 

After it has been evicted to swap, its `swap_slot` identifies where its contents are stored. When the page is brought back, the contents must be read from that slot and the slot can then be released.

### File-backed pages

File-backed pages have a file ID and file offset identifying their backing location.

If a file-backed page is **clean**, its in-memory contents are already the same as the backing store, so it can simply be discarded during eviction. 

If a file-backed page is **dirty**, its in-memory contents are newer than the backing store. It must therefore be written back before the frame is reused.

---

## 3. Page metadata

You will obtain page information using `sim_get_page_info(page_id)`.

It returns a `PageInfo` structure containing the following fields:

```c
typedef struct {
    int page_id;
    bool resident;
    int frame_id;
    bool dirty;
    PageType type;
    int swap_slot;
    int file_id;
    size_t file_offset;
    uint64_t last_access_time;
} PageInfo;
```

Here is what each field means.

### `page_id`

The virtual page number. This is the identifier you use when referring to a page.

### `resident`

`true` means that the page is currently present in physical memory.

`false` means that the page is not currently mapped to a physical frame.

Only **resident** pages are candidates for eviction.

### `frame_id`

The physical frame currently containing the page.

If the page is not resident, this is `-1`.

### `dirty`

`true` means the page has been modified since it was most recently loaded into RAM or initialized.

`false` means it has not been modified since that load or initialization.

The dirty bit is used both by the **four-category victim-selection policy** and by file-backed eviction. It has different effects depending on page type:

- dirty anonymous page -> still save it to swap; its category is lower priority than clean anonymous and clean file-backed pages,
- clean anonymous page -> still save it to swap when evicted, even though it ranks in category 1,
- dirty file-backed page -> write it back to the file,
- clean file-backed page -> no write-back is needed.

The simulator clears this flag when a page is loaded or evicted. You should not try to maintain it yourself. In this simplified lab, it is a current modified-since-load flag; do not interpret `dirty == false` as proof that anonymous contents can be discarded.

### `type`

The backing type of the page:

```c
PAGE_ANON   // anonymous page
PAGE_FILE   // file-backed page
```

This is used by the eviction policy and tells you whether the page belongs to swap-backed or file-backed memory.

### `swap_slot`

For an anonymous page, this is the swap slot containing its saved contents, or `-1` if it currently has no swap slot.

A swap slot is normally present only after an anonymous page has been evicted.

For a file-backed page, this field is not used and will be `-1`.

### `file_id`

The identifier of the backing file for a file-backed page.

For anonymous pages this is not meaningful.

Pass this value to the file I/O APIs when reading or writing a file-backed page.

### `file_offset`

The offset inside the backing file corresponding to this page.

Pass this value to the file I/O APIs when reading or writing a file-backed page.

### `last_access_time`

A logical timestamp maintained by the simulator.

Every virtual memory access advances the simulator clock and updates this value for the accessed page.

For this lab, **a smaller `last_access_time` means the page was used less recently**.

Use this field to implement LRU. You do not need to maintain the timestamp yourself.

---

## 4. Eviction policy: four priority buckets + LRU

This lab uses a **fixed four-level eviction priority**. Consider only resident pages and place each page into exactly one category based on its type and current `dirty` flag:

1. **Anonymous, clean** (`PAGE_ANON`, `dirty == false`)
2. **File-backed, clean** (`PAGE_FILE`, `dirty == false`)
3. **Anonymous, dirty** (`PAGE_ANON`, `dirty == true`)
4. **File-backed, dirty** (`PAGE_FILE`, `dirty == true`)

Choose a victim from the **highest-priority non-empty category** (the category with the smallest number above). Within that category, choose the least-recently-used page: the one with the smallest `last_access_time`. If two pages in the same category have the same timestamp, choose the smaller `page_id` to make the result deterministic.

**Category priority comes before recency across categories.** For example, an anonymous clean page is chosen before a file-backed clean page even if the file-backed page has an older timestamp. LRU is used only to choose between pages in the same category.

The selection can be visualized as:

```text
             Resident pages
                    |
                    v
       +---------------------------+
       | 1. Anonymous and clean?   | -- yes --> LRU in category 1
       +-------------+-------------+
                     | no
                     v
       +---------------------------+
       | 2. File-backed and clean? | -- yes --> LRU in category 2
       +-------------+-------------+
                     | no
                     v
       +---------------------------+
       | 3. Anonymous and dirty?   | -- yes --> LRU in category 3
       +-------------+-------------+
                     | no
                     v
       +---------------------------+
       | 4. File-backed and dirty? | -- yes --> LRU in category 4
       +-------------+-------------+
                     | no
                     v
             Return -1 (no resident page)
```

### Important distinction: victim priority vs. eviction behavior

The `dirty` flag affects **which category a page belongs to**, but it does not change the backing-store rules:

- **Every anonymous page must be preserved in swap when evicted**, including an anonymous page whose `dirty` flag is false. A clean anonymous page may still contain data that cannot be reconstructed from a file.
- A **clean file-backed page** can be discarded without write-back because the backing file can supply its contents again.
- A **dirty file-backed page** must be written back before it is discarded.

This is a deliberately defined teaching policy for the lab, not a claim that every real operating system uses this exact ordering.

The victim-selection function returns a **page ID**, not a frame ID. Return `-1` only if no page is resident.

---

## 5. APIs provided by the simulator

The simulator exposes a small public API. You should use these functions instead of accessing its internal data structures directly.

### Inspecting pages

```c
int sim_page_count(void);
PageInfo sim_get_page_info(int page_id);
```

`sim_page_count()` returns the number of virtual pages in the simulator.

`sim_get_page_info(page_id)` gives you a snapshot of the metadata for that page.

For victim selection, you will normally call `sim_get_page_info()` while scanning the pages.

---

### Swap APIs

```c
int sim_alloc_swap_slot(void);
void sim_free_swap_slot(int slot);
void sim_read_from_swap(int frame_id, int swap_slot);
void sim_write_to_swap(int frame_id, int swap_slot);
```

#### `sim_alloc_swap_slot()`

Allocates a free swap slot and returns its slot number.

You need this when evicting an anonymous page that does not already have a swap slot.

#### `sim_free_swap_slot(slot)`

Marks a swap slot as free again.

When an anonymous page is successfully loaded from swap, its old slot is no longer needed, so the slot should be released.

#### `sim_write_to_swap(frame_id, swap_slot)`

Copies the contents of a physical frame into the specified swap slot.

Use this during anonymous-page eviction.

#### `sim_read_from_swap(frame_id, swap_slot)`

Copies the contents of a swap slot into a physical frame.

Use this when loading an anonymous page that has previously been evicted.

---

### File-backing APIs

```c
void sim_read_from_file(int frame_id, int file_id, size_t offset);
void sim_write_to_file(int frame_id, int file_id, size_t offset);
```

#### `sim_read_from_file(frame_id, file_id, offset)`

Loads the page identified by `file_id` and `offset` into the specified frame.

Use this whenever a file-backed page is loaded into memory.

#### `sim_write_to_file(frame_id, file_id, offset)`

Writes the contents of the specified frame back to the page's backing file.

Use this **only for dirty file-backed pages during eviction**.

A clean file-backed page does not require this call.

---

### Zero-fill API

```c
void sim_zero_fill_frame(int frame_id);
```

Initializes the frame with zeroes.

Use this when an anonymous page is being loaded for the first time and therefore has no swap contents to restore.

---

### Metadata update APIs

The simulator owns the real page-table/frame bookkeeping. After performing the actual data movement, use these helpers to tell the simulator what happened.

```c
void sim_mark_page_evicted(int page_id);
void sim_set_swap_slot(int page_id, int slot);
void sim_mark_page_loaded(int page_id, int frame_id);
```

#### `sim_mark_page_evicted(page_id)`

Marks the page as non-resident and releases its mapping to the old physical frame.

Call this **after** completing any required swap write or file write-back.

For an anonymous page, this does not by itself allocate a swap slot. You must allocate the slot and associate it with the page first.

#### `sim_set_swap_slot(page_id, slot)`

Records which swap slot belongs to an anonymous page.

Typical anonymous eviction sequence:

```text
find page's current swap_slot
        |
        +-- slot == -1 --> allocate a new slot
        |
        v
write frame -> swap slot
        |
associate slot with page
        |
mark page evicted
```

#### `sim_mark_page_loaded(page_id, frame_id)`

Marks the page as resident in the specified frame and updates the simulator's mapping metadata.

Call this after the page's contents have been loaded into the frame.

---

## 6. The three functions you must implement

You only need to edit `paging.c` and implement these three functions.

### Task 1: `select_victim_page(void)`

Choose a victim according to the four priority buckets in Section 4.

Requirements:

- consider only resident pages,
- rank each page as anonymous-clean, file-backed-clean, anonymous-dirty, or file-backed-dirty, in that order,
- choose from the first non-empty category,
- within that category, choose the smallest `last_access_time`,
- break equal-timestamp ties using the smaller `page_id`,
- return the victim's **page ID**,
- return `-1` only when there are no resident pages at all.

You can implement this with four scans (one per category) or one scan that compares both category priority and LRU timestamp.

---

### Task 2: `evict_page(int victim_page_id)`

Evict the specified resident page from physical memory.

#### Anonymous page

1. Read its metadata.
2. If `swap_slot == -1`, allocate a swap slot.
3. Write the page's frame contents to swap.
4. Record the swap slot using `sim_set_swap_slot()`.
5. Mark the page as evicted using `sim_mark_page_evicted()`.

#### File-backed page

1. Read its metadata.
2. If `dirty == true`, write the frame back using `sim_write_to_file()`.
3. If the page is clean, do not perform file write-back.
4. Mark the page as evicted using `sim_mark_page_evicted()`.

Do not manually modify the simulator's internal metadata.

---

### Task 3: `load_page(int page_id, int frame_id)`

Load the specified page into the specified frame.

#### Anonymous page

- If `swap_slot != -1`, read the page from swap and then free that swap slot.
- If `swap_slot == -1`, this is a first-touch anonymous page, so zero-fill the frame.

#### File-backed page

- Read the page from its backing file using its `file_id` and `file_offset`.

After the contents have been placed in the frame, call:

```c
sim_mark_page_loaded(page_id, frame_id);
```

This updates the simulator's mapping and LRU metadata.

---

## 7. What you should NOT modify

Do not modify the simulator framework or the page-fault handler.

In particular, the provided `handle_page_fault()` is responsible for:

- finding a free frame,
- calling `select_victim_page()` with no arguments when all frames are occupied,
- obtaining the victim's frame,
- calling `evict_page()`,
- calling `load_page()` for the requested page.

Your code should implement the requested policy rather than rewriting the framework.

---

## 8. Building your submission

There is intentionally no `main.c` in the student package. The lab is a library-style exercise: you implement the paging logic, and the included command-file harness calls it for testing.

Build the framework and your `paging.c` into object files with:

```bash
make
```

A successful build produces:

```text
sim_framework.o
paging.o
```

Run the included public tests with:

```bash
make test
make test N=5
make test N="1 3 5"
```

The test command links your implementation with `paging_test_driver.c`, runs each selected command file in a fresh simulator, and compares its output with the matching expected-output JSON. A failure includes a unified diff. You should not add your own `main()` function.

To remove generated object files:

```bash
make clean
```

This package includes all 14 tests as public cases, along with the runner and expected outputs.

---

## 9. Suggested way to think about the problem

Before writing code, ask these questions for every operation:

**Victim selection:**

> What is the highest-priority non-empty category, and which page in that category has the oldest timestamp?

**Eviction:**

> If I throw this page out of RAM right now, where must its current contents go so that I can reconstruct them later?

**Loading:**

> Where is the authoritative copy of this page right now—swap, file, or nowhere because this is a brand-new anonymous page?

That is the main idea behind demand paging in this simplified simulator.
