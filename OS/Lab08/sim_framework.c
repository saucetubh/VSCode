#include "paging_sim.h"
#include <string.h>

/*
 * Stores a page's metadata inside the simulator. paging.c reads and updates
 * this metadata through the simulator APIs.
 */
typedef struct {
    bool resident;             /* true if the page is in memory. */
    int frame_id;               /* Number of the physical frame containing this page, or -1 if it is not resident. */
    bool dirty;                 /* true if this page is dirty (modified since the last load). */
    bool referenced;            /* Reference bit used by the replacement policy. */
    PageType type;
    int swap_slot;              /* Swap slot number for this page, or -1 if none is assigned. */
    int file_id;                /* File ID for file-backed pages, or -1 for anonymous pages. */
    size_t file_offset;         /* Byte offset in the backing file. */
    uint64_t last_access_time;  /* Last access timestamp. */
} InternalPage;

typedef struct {
    uint8_t data[PAGE_SIZE];    /* Frame contents. */
    bool occupied;              /* true if a page is mapped to this frame. */
    int mapped_page_id;         /* Page ID, or -1 if the frame is free. */
} InternalFrame;

typedef struct {
    InternalPage pages[NUM_PAGES];
    InternalFrame frames[NUM_FRAMES];                /* Simulated physical memory. */
    uint8_t swap_space[MAX_SWAP_SLOTS][PAGE_SIZE];   /* Swap slot contents. */
    bool swap_free_bitmap[MAX_SWAP_SLOTS];           /* true if the slot is free. */
    uint8_t file_space[6][PAGE_SIZE];                /* Backing file contents. */
    uint64_t global_clock;                           /* Increases on each read or write. */
} InternalState;

static InternalState sys;

/* Initializes the simulator with all pages nonresident and all physical frames free. */
void sim_init(void) {
    memset(&sys, 0, sizeof(sys));

    for (int i = 0; i < MAX_SWAP_SLOTS; i++)
        sys.swap_free_bitmap[i] = true;

    for (int i = 0; i < NUM_FRAMES; i++) {
        sys.frames[i].occupied = false;
        sys.frames[i].mapped_page_id = -1;
    }

    /* The backing file starts with 0xAB in every byte. */
    for (int i = 0; i < 6; i++)
        memset(sys.file_space[i], 0xAB, PAGE_SIZE);

    /* Pages 0-5 are anonymous; pages 6-11 use file 101. */
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

/* Returns the number of virtual pages in the simulator. */
int sim_page_count(void) {
    return NUM_PAGES;
}

/*
 * Returns a copy of the metadata for page page_id. Changing the returned
 * PageInfo does not change the page's stored metadata.
 *
 * TODO: Include the reference bit in the returned page information.
 */
PageInfo sim_get_page_info(int page_id) {
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
        .last_access_time = p->last_access_time,
        .referenced = p->referenced
    };
    return out;
}

/*
 * Reserves the lowest-numbered free swap slot and returns its slot number.
 * Terminates the program with an error if no free slot is available.
 */
int sim_alloc_swap_slot(void) {
    for (int i = 0; i < MAX_SWAP_SLOTS; i++) {
        if (sys.swap_free_bitmap[i]) {
            sys.swap_free_bitmap[i] = false;
            return i;
        }
    }
    printf("[SIM ERROR] Out of swap space!\n");
    exit(EXIT_FAILURE);
}

/*
 * Marks swap slot slot as free so it can be allocated again. Ignores slot
 * if it is outside the valid swap-slot range.
 */
void sim_free_swap_slot(int slot) {
    if (slot >= 0 && slot < MAX_SWAP_SLOTS)
        sys.swap_free_bitmap[slot] = true;
}

/* Copies one complete page from swap slot swap_slot into physical frame frame_id. */
void sim_read_from_swap(int frame_id, int swap_slot) {
    printf("  [DISK I/O] SWAP IN: Slot %d -> Frame %d\n", swap_slot, frame_id);
    memcpy(sys.frames[frame_id].data, sys.swap_space[swap_slot], PAGE_SIZE);
}

/* Copies one complete page from physical frame frame_id into swap slot swap_slot. */
void sim_write_to_swap(int frame_id, int swap_slot) {
    printf("  [DISK I/O] SWAP OUT: Frame %d -> Swap Slot %d\n", frame_id, swap_slot);
    memcpy(sys.swap_space[swap_slot], sys.frames[frame_id].data, PAGE_SIZE);
}

/* Reads one complete page from file file_id, starting at byte offset offset, into physical frame frame_id. */
void sim_read_from_file(int frame_id, int file_id, size_t offset) {
    int file_page = (int)(offset / PAGE_SIZE);
    printf("  [FILE I/O] READ FILE (ID %d, Offset %zu) -> Frame %d\n",
           file_id, offset, frame_id);
    memcpy(sys.frames[frame_id].data, sys.file_space[file_page], PAGE_SIZE);
}

/* Writes one complete page from physical frame frame_id to file file_id, starting at byte offset offset. */
void sim_write_to_file(int frame_id, int file_id, size_t offset) {
    int file_page = (int)(offset / PAGE_SIZE);
    printf("  [FILE I/O] WRITE-BACK DIRTY FILE (ID %d, Offset %zu) <- Frame %d\n",
           file_id, offset, frame_id);
    memcpy(sys.file_space[file_page], sys.frames[frame_id].data, PAGE_SIZE);
}

/* Sets every byte in physical frame frame_id to zero. */
void sim_zero_fill_frame(int frame_id) {
    memset(sys.frames[frame_id].data, 0, PAGE_SIZE);
}

/* Records slot as the swap slot assigned to page page_id. */
void sim_set_swap_slot(int page_id, int slot) {
    sys.pages[page_id].swap_slot = slot;
}

/* Sets the reference bit of page page_id to value. */
void sim_set_referenced(int page_id, bool value) {
    sys.pages[page_id].referenced = value;
}

/*
 * Marks page page_id as nonresident and releases its physical frame.
 * Clears its frame mapping, dirty bit and reference bit.
 */
void sim_mark_page_evicted(int page_id) {
    InternalPage *p = &sys.pages[page_id];
    int frame_id = p->frame_id;

    p->resident = false;
    p->frame_id = -1;
    p->dirty = false;
    p->referenced = false;

    if (frame_id >= 0 && frame_id < NUM_FRAMES) {
        sys.frames[frame_id].occupied = false;
        sys.frames[frame_id].mapped_page_id = -1;
    }
}

/*
 * Maps page page_id to physical frame frame_id and marks it resident and
 * clean. Sets its last-access timestamp to the current simulator
 * timestamp.
 */
void sim_mark_page_loaded(int page_id, int frame_id) {
    InternalPage *p = &sys.pages[page_id];
    p->resident = true;
    p->frame_id = frame_id;
    p->dirty = false;
    p->last_access_time = sys.global_clock;

    sys.frames[frame_id].occupied = true;
    sys.frames[frame_id].mapped_page_id = page_id;
}

/*
 * Reads and returns the byte at offset offset within page page_id. If the
 * page is nonresident, it calls the page fault handler before reading it.
 * Updates the page's last-access timestamp.
 *
 * TODO: Update the reference bit for resident reads according to the policy.
 */
uint8_t read_virtual_memory(int page_id, size_t offset) {
    if (offset >= PAGE_SIZE) {
        printf("[SIM ERROR] Invalid offset %zu\n", offset);
        exit(EXIT_FAILURE);
    }

    sys.global_clock++;
    if (!sys.pages[page_id].resident)
        handle_page_fault(page_id);

    InternalPage *p = &sys.pages[page_id];
    p->last_access_time = sys.global_clock;
    p->referenced = true;
    return sys.frames[p->frame_id].data[offset];
}

/*
 * Writes value to the byte at offset offset within page page_id. If the
 * page is nonresident, it calls the page fault handler before writing it.
 * Marks the page dirty and updates its last-access timestamp.
 *
 * TODO: Update the reference bit for resident writes according to the policy.
 */
void write_virtual_memory(int page_id, size_t offset, uint8_t value) {
    if (offset >= PAGE_SIZE) {
        printf("[SIM ERROR] Invalid offset %zu\n", offset);
        exit(EXIT_FAILURE);
    }

    sys.global_clock++;
    if (!sys.pages[page_id].resident)
        handle_page_fault(page_id);

    InternalPage *p = &sys.pages[page_id];
    p->dirty = true;
    p->last_access_time = sys.global_clock;
    p->referenced = true;
    sys.frames[p->frame_id].data[offset] = value;
}
