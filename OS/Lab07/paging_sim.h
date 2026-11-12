#ifndef PAGING_SIM_H
#define PAGING_SIM_H

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define PAGE_SIZE 64
#define NUM_FRAMES 4
#define NUM_PAGES 12
#define MAX_SWAP_SLOTS 16

typedef enum {
    PAGE_ANON,
    PAGE_FILE
} PageType;

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

/*
 * Simulator/framework APIs.
 *
 * These functions form the interface available to student code.
 * Do not access the simulator's internal state directly.
 */
void sim_init(void);
int sim_page_count(void);
PageInfo sim_get_page_info(int page_id);

int sim_alloc_swap_slot(void);
void sim_free_swap_slot(int slot);
void sim_read_from_swap(int frame_id, int swap_slot);
void sim_write_to_swap(int frame_id, int swap_slot);
void sim_read_from_file(int frame_id, int file_id, size_t offset);
void sim_write_to_file(int frame_id, int file_id, size_t offset);
void sim_zero_fill_frame(int frame_id);

void sim_mark_page_evicted(int page_id);
void sim_set_swap_slot(int page_id, int slot);
void sim_mark_page_loaded(int page_id, int frame_id);

/* Student deliverables. */
int select_victim_page(void);
void evict_page(int victim_page_id);
void load_page(int page_id, int frame_id);
/* Provided page-fault handler. Do not modify. */
int handle_page_fault(int page_id);

#endif
