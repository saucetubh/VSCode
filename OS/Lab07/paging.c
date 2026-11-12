#include "paging_sim.h"

/*
 * TASK 1: select_victim_page
 *
 * Select one resident page using these priority categories, in order:
 *   1. anonymous + clean
 *   2. file-backed + clean
 *   3. anonymous + dirty
 *   4. file-backed + dirty
 *
 * Within the first non-empty category, choose the page with the smallest
 * last_access_time (LRU). Break timestamp ties using the smaller page_id.
 * Return the page ID, or -1 if no page is resident.
 */

int get_priority(PageInfo* pg) {
    if(pg->type == PAGE_ANON && pg->dirty == false) return 1;
    else if(pg->type == PAGE_FILE && pg->dirty == false) return 2;
    else if(pg->type == PAGE_ANON && pg->dirty == true) return 3;
    else if(pg->type == PAGE_FILE && pg->dirty == true) return 4;
    else return 5;
}
int select_victim_page(void) {
    // TODO 1: Implement the four-category priority + LRU policy.
    int pg_id = -1;
    for(int i=0;i<sim_page_count();i++) {
        PageInfo candidate = sim_get_page_info(i);
        if(!candidate.resident) continue;
        if(pg_id == -1) {
            pg_id = candidate.page_id;
            continue;
        }
        PageInfo victim = sim_get_page_info(pg_id);
        if(get_priority(&candidate) < get_priority(&victim)) pg_id = candidate.page_id;
        else if(get_priority(&candidate) == get_priority(&victim)) {
            if(candidate.last_access_time < victim.last_access_time) pg_id = candidate.page_id;
            else if(candidate.last_access_time == victim.last_access_time) {
                if(candidate.page_id < victim.page_id) pg_id = candidate.page_id;
            }
        }
    }
    return pg_id;
}

/*
 * TASK 2: evict_page
 *
 * Anonymous page:
 *   - always preserve its contents in swap, regardless of dirty state
 *   - allocate a swap slot if it does not already have one
 *   - write the frame contents to that slot
 *
 * File-backed page:
 *   - if dirty, write the frame back to the backing file
 *   - if clean, skip write-back
 *
 * Finish by marking the page non-resident with sim_mark_page_evicted().
 */
void evict_page(int victim_page_id) {
    // TODO 2
    PageInfo pg = sim_get_page_info(victim_page_id);
    if(pg.type == PAGE_ANON) {
        int ss;
        if(pg.swap_slot == -1) ss = sim_alloc_swap_slot();
        else ss=pg.swap_slot;
        sim_write_to_swap(pg.frame_id, ss);
        sim_set_swap_slot(victim_page_id, ss);
    }
    if(pg.type == PAGE_FILE) {
        if(pg.dirty) {
            sim_write_to_file(pg.frame_id, pg.file_id, pg.file_offset);
        }
    }
    sim_mark_page_evicted(victim_page_id);
}

/*
 * TASK 3: load_page
 *
 * Anonymous page:
 *   - if it has a swap slot, read from swap and free the slot
 *   - otherwise, this is a first-touch page: zero-fill the frame
 *
 * File-backed page:
 *   - read the page from its backing file
 *
 * Finish by recording the mapping with sim_mark_page_loaded().
 */
void load_page(int page_id, int frame_id) {
    // TODO 3
    PageInfo pg = sim_get_page_info(page_id);
    if(pg.type == PAGE_ANON) {
        if(pg.swap_slot == -1) sim_zero_fill_frame(frame_id);
        else {
            sim_read_from_swap(frame_id, pg.swap_slot);
            sim_free_swap_slot(pg.swap_slot);
        }
    }
    if(pg.type == PAGE_FILE) {
        sim_read_from_file(frame_id, pg.file_id, pg.file_offset);
    }
    sim_mark_page_loaded(page_id, frame_id);
}

/*
 * PROVIDED: do not modify.
 * Finds a free frame, or selects and evicts a victim, then loads the faulting
 * page into the assigned frame.
 */
int handle_page_fault(int page_id) {
    PageInfo faulting = sim_get_page_info(page_id);
    printf("[PAGE FAULT] Page %d (%s)\n",
           page_id, faulting.type == PAGE_ANON ? "ANON" : "FILE");

    int assigned_frame = -1;
    for (int i = 0; i < NUM_FRAMES; i++) {
        bool used = false;
        for (int p = 0; p < sim_page_count(); p++) {
            PageInfo owner = sim_get_page_info(p);
            if (owner.resident && owner.frame_id == i) {
                used = true;
                break;
            }
        }
        if (!used) {
            assigned_frame = i;
            break;
        }
    }

    if (assigned_frame == -1) {
        int victim_id = select_victim_page();
        assigned_frame = sim_get_page_info(victim_id).frame_id;
        evict_page(victim_id);
    }

    load_page(page_id, assigned_frame);
    return assigned_frame;
}
