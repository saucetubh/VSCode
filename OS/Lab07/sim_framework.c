#include "paging_sim.h"
#include <string.h>

/*
 * This file implements the simulator's low-level memory and backing-store
 * operations.  The page-fault policy (which frame to use, which page to evict,
 * and which backing store to consult) is implemented elsewhere.
 *
 * The structures below are deliberately private to this file.  Other parts of
 * the lab interact with them through the functions declared in paging_sim.h,
 * which keeps the simulated hardware state separate from the policy code.
 */
typedef struct {
    bool resident;             /* Whether this virtual page currently has a frame. */
    int frame_id;               /* Its physical frame, or -1 when non-resident. */
    bool dirty;                 /* Whether it has been written since it was loaded. */
    PageType type;              /* Anonymous (swap-backed) or file-backed. */
    int swap_slot;              /* Saved anonymous-page contents, or -1 if none. */
    int file_id;                /* Backing file identifier for file-backed pages. */
    size_t file_offset;         /* Offset of this page within its backing file. */
    uint64_t last_access_time;  /* Logical time of the most recent access. */
} InternalPage;

typedef struct {
    uint8_t data[PAGE_SIZE];    /* Bytes currently stored in this physical frame. */
    bool occupied;              /* True when a virtual page is mapped to the frame. */
    int mapped_page_id;         /* The mapped virtual page, or -1 if the frame is free. */
} InternalFrame;

typedef struct {
    InternalPage pages[NUM_PAGES];                  /* Metadata for every virtual page. */
    InternalFrame frames[NUM_FRAMES];                /* Simulated physical memory. */
    uint8_t swap_space[MAX_SWAP_SLOTS][PAGE_SIZE];   /* Persistent copies of evicted anon pages. */
    bool swap_free_bitmap[MAX_SWAP_SLOTS];           /* true means the slot is available. */
    uint8_t file_space[6][PAGE_SIZE];                /* Six file-backed page images. */
    uint64_t global_clock;                           /* Advances once for each VM access. */
} InternalState;

/* One process-wide simulated machine state, reset by sim_init(). */
static InternalState sys;

void sim_init(void) {
    /* Start with deterministic, empty memory and backing-store metadata. */
    memset(&sys, 0, sizeof(sys));

    /* Swap slots are tracked separately from their byte contents.  A true bit
     * indicates that a later anonymous-page eviction may claim the slot. */
    for (int i = 0; i < MAX_SWAP_SLOTS; i++)
        sys.swap_free_bitmap[i] = true;

    /* Zeroing the whole state cleared the frame bytes, but free frames must
     * also use the explicit sentinel for "no virtual page mapped here." */
    for (int i = 0; i < NUM_FRAMES; i++) {
        sys.frames[i].occupied = false;
        sys.frames[i].mapped_page_id = -1;
    }

    /* Give the six simulated file pages a recognizable initial pattern.  This
     * makes it possible to tell file reads from zero-filled anonymous pages. */
    for (int i = 0; i < 6; i++)
        memset(sys.file_space[i], 0xAB, PAGE_SIZE);

    /* Initialize every virtual page as non-resident.  Pages 0-5 are anonymous
     * and start with no swap copy; pages 6-11 map to consecutive pages in the
     * simulated file with ID 101. */
    for (int i = 0; i < NUM_PAGES; i++) {
        sys.pages[i].resident = false;
        sys.pages[i].frame_id = -1;
        sys.pages[i].dirty = false;
        sys.pages[i].swap_slot = -1;
        sys.pages[i].last_access_time = 0;

        if (i < 6) {
            sys.pages[i].type = PAGE_ANON;
            sys.pages[i].file_id = -1;
            sys.pages[i].file_offset = 0;
        } else {
            sys.pages[i].type = PAGE_FILE;
            sys.pages[i].file_id = 101;
            sys.pages[i].file_offset = (size_t)(i - 6) * PAGE_SIZE;
        }
    }
}

int sim_page_count(void) {
    /* Expose the configured virtual address-space size to policy code. */
    return NUM_PAGES;
}

PageInfo sim_get_page_info(int page_id) {
    /* Copy the private metadata into the public structure.  Returning a copy
     * prevents callers from directly changing the simulator's internal state. */
    InternalPage *p = &sys.pages[page_id];
    PageInfo out = {
        .page_id = page_id,
        .resident = p->resident,
        .frame_id = p->frame_id,
        .dirty = p->dirty,
        .type = p->type,
        .swap_slot = p->swap_slot,
        .file_id = p->file_id,
        .file_offset = p->file_offset,
        .last_access_time = p->last_access_time
    };
    return out;
}

int sim_alloc_swap_slot(void) {
    /* Use the first available slot to keep allocation deterministic. */
    for (int i = 0; i < MAX_SWAP_SLOTS; i++) {
        if (sys.swap_free_bitmap[i]) {
            sys.swap_free_bitmap[i] = false;
            return i;
        }
    }
    /* The lab configuration is expected to provide enough swap.  Treat an
     * exhausted swap area as a fatal simulator error rather than returning an
     * invalid slot to the page-fault handler. */
    printf("[SIM ERROR] Out of swap space!\n");
    exit(EXIT_FAILURE);
}

void sim_free_swap_slot(int slot) {
    /* Mark a valid slot available again.  Invalid values are ignored so that
     * cleanup paths can safely pass an unset sentinel such as -1. */
    if (slot >= 0 && slot < MAX_SWAP_SLOTS)
        sys.swap_free_bitmap[slot] = true;
}

void sim_read_from_swap(int frame_id, int swap_slot) {
    /* Restore a complete page from its saved swap image into a physical frame. */
    printf("  [DISK I/O] SWAP IN: Slot %d -> Frame %d\n", swap_slot, frame_id);
    memcpy(sys.frames[frame_id].data, sys.swap_space[swap_slot], PAGE_SIZE);
}

void sim_write_to_swap(int frame_id, int swap_slot) {
    /* Preserve a complete frame before its contents are overwritten or reused. */
    printf("  [DISK I/O] SWAP OUT: Frame %d -> Swap Slot %d\n", frame_id, swap_slot);
    memcpy(sys.swap_space[swap_slot], sys.frames[frame_id].data, PAGE_SIZE);
}

void sim_read_from_file(int frame_id, int file_id, size_t offset) {
    /* Convert a byte offset into the page index in the simulated file image.
     * This lab uses one file with six page-sized regions. */
    int file_page = (int)(offset / PAGE_SIZE);
    printf("  [FILE I/O] READ FILE (ID %d, Offset %zu) -> Frame %d\n",
           file_id, offset, frame_id);
    memcpy(sys.frames[frame_id].data, sys.file_space[file_page], PAGE_SIZE);
}

void sim_write_to_file(int frame_id, int file_id, size_t offset) {
    /* Write a dirty file-backed page's full frame image back to its matching
     * page in the simulated file store. */
    int file_page = (int)(offset / PAGE_SIZE);
    printf("  [FILE I/O] WRITE-BACK DIRTY FILE (ID %d, Offset %zu) <- Frame %d\n",
           file_id, offset, frame_id);
    memcpy(sys.file_space[file_page], sys.frames[frame_id].data, PAGE_SIZE);
}

void sim_zero_fill_frame(int frame_id) {
    /* A first-time anonymous page has no backing image, so it reads as zeros. */
    printf("  [MEM] ZERO-FILL: Initializing Frame %d\n", frame_id);
    memset(sys.frames[frame_id].data, 0, PAGE_SIZE);
}

void sim_set_swap_slot(int page_id, int slot) {
    /* Record where the page-fault policy saved this page's anonymous contents. */
    sys.pages[page_id].swap_slot = slot;
}

void sim_mark_page_evicted(int page_id) {
    /* Remove the page-to-frame association and make its former frame reusable.
     * The policy must save any data that needs preserving before calling this. */
    InternalPage *p = &sys.pages[page_id];
    int frame_id = p->frame_id;

    p->resident = false;
    p->frame_id = -1;
    p->dirty = false;

    if (frame_id >= 0 && frame_id < NUM_FRAMES) {
        sys.frames[frame_id].occupied = false;
        sys.frames[frame_id].mapped_page_id = -1;
    }
}

void sim_mark_page_loaded(int page_id, int frame_id) {
    /* Establish the page/frame mapping after the policy has populated the frame
     * (by zero-fill, swap-in, or file read).  A newly loaded page starts clean. */
    InternalPage *p = &sys.pages[page_id];

    p->resident = true;
    p->frame_id = frame_id;
    p->dirty = false;
    p->swap_slot = -1;
    p->last_access_time = sys.global_clock;

    sys.frames[frame_id].occupied = true;
    sys.frames[frame_id].mapped_page_id = page_id;
}

uint8_t read_virtual_memory(int page_id, size_t offset) {
    /* Reject offsets outside the single page before touching simulated state. */
    if (offset >= PAGE_SIZE) {
        printf("[SIM ERROR] Invalid offset %zu\n", offset);
        exit(EXIT_FAILURE);
    }

    /* Each read is one logical memory access.  A missing page is resolved by
     * the policy's fault handler, after which the requested byte is available. */
    sys.global_clock++;
    if (!sys.pages[page_id].resident)
        handle_page_fault(page_id);

    /* Update recency after fault handling as well, then return the selected byte. */
    InternalPage *p = &sys.pages[page_id];
    p->last_access_time = sys.global_clock;
    return sys.frames[p->frame_id].data[offset];
}

void write_virtual_memory(int page_id, size_t offset, uint8_t value) {
    /* A write is also a single-page operation; callers must not cross a page
     * boundary through this interface. */
    if (offset >= PAGE_SIZE) {
        printf("[SIM ERROR] Invalid offset %zu\n", offset);
        exit(EXIT_FAILURE);
    }

    /* Resolve a fault before modifying the target page.  The page-fault handler
     * returns only after the page has been mapped to a valid physical frame. */
    sys.global_clock++;
    if (!sys.pages[page_id].resident)
        handle_page_fault(page_id);

    /* Record the modification for eviction policy and file write-back, update
     * its recency, and finally store the requested byte in the frame. */
    InternalPage *p = &sys.pages[page_id];
    p->dirty = true;
    p->last_access_time = sys.global_clock;
    sys.frames[p->frame_id].data[offset] = value;
}
