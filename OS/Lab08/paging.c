#include "paging_sim.h"

/*
 * Chooses a resident page for eviction according to the replacement policy
 * and returns its page ID. Updates reference bits and the saved starting
 * frame as required by the policy. The selected page remains resident.
 *
 * TODO: Implement this function.
 */
int get_pgid_at_frame(int hand) {
    for(int i=0;i<sim_page_count();i++) {
        PageInfo pg = sim_get_page_info(i);
        if(pg.frame_id == hand) {
            return pg.page_id;
        }
    }
    return -1;
}
int hand = 0;
int select_victim_page(void) {
    int pgid = -1;
    for(int i=0;i<4;i++) {
        if(hand>3) hand=0;
        PageInfo candidate = sim_get_page_info(get_pgid_at_frame(hand));
        hand++;
        if(candidate.dirty == false && candidate.referenced == false) {
            pgid = candidate.page_id;
            hand--;
            return pgid;
        }
    }
    if(hand>3) hand=0;
    for(int i=0;i<4;i++) {
        if(hand>3) hand=0;
        PageInfo candidate = sim_get_page_info(get_pgid_at_frame(hand));
        hand++;
        if(candidate.dirty == true && candidate.referenced == false) {
            pgid = candidate.page_id;
            hand--;
            return pgid;
        }
        else {
            sim_set_referenced(candidate.page_id, false);
        }
    }
    if(hand>3) hand=0;
    return select_victim_page();
}

/*
 * Evicts resident page victim_page_id, saving its contents when required
 * by the backing-store rules, and releases its physical frame.
 *
 * TODO: Implement this function.
 */
void evict_page(int victim_page_id) {
    PageInfo pg = sim_get_page_info(victim_page_id);
    if(pg.type == PAGE_ANON) {
        if(pg.dirty) {
            int ss = pg.swap_slot;
            if(ss == -1) {
                ss = sim_alloc_swap_slot();
                sim_set_swap_slot(victim_page_id, ss);
            }
            sim_write_to_swap(pg.frame_id, ss);
        }
    }
    if(pg.type == PAGE_FILE) {
        if(pg.dirty) {
            sim_write_to_file(pg.frame_id, pg.file_id, pg.file_offset);
        }
    }
    sim_mark_page_evicted(victim_page_id);
}

/*
 * Loads nonresident page page_id into free physical frame frame_id.
 * Restores or initializes its contents and updates the page and frame
 * metadata according to the policy.
 *
 * TODO: Implement this function.
 */
void load_page(int page_id, int frame_id) {
    PageInfo pg = sim_get_page_info(page_id);
    if(pg.type == PAGE_ANON) {
        if(pg.swap_slot == -1) {
            sim_zero_fill_frame(frame_id);
        }
        else {
            sim_read_from_swap(frame_id, pg.swap_slot);
        }
    }
    if(pg.type == PAGE_FILE) {
        sim_read_from_file(frame_id, pg.file_id, pg.file_offset);
    }
    sim_mark_page_loaded(page_id, frame_id);
}

/*
 * Handles a page fault for nonresident page page_id and returns its frame
 * ID. Uses the lowest-numbered free frame, evicting a page according to
 * the replacement policy if memory is full, then loads page_id into that
 * frame. This function is provided. Do not modify it.
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
