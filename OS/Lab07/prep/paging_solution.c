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
int select_victim_page(void) {
    int best = -1;
    int best_cat = 5;
    uint64_t best_time = 0;

    for (int p = 0; p < sim_page_count(); p++) {
        PageInfo info = sim_get_page_info(p);
        if (!info.resident)
            continue;

        int cat;
        if (info.type == PAGE_ANON && !info.dirty)      cat = 1;
        else if (info.type == PAGE_FILE && !info.dirty) cat = 2;
        else if (info.type == PAGE_ANON)                cat = 3;
        else                                            cat = 4;

        /* Strict < on both keys + ascending scan => smaller page_id wins ties. */
        if (cat < best_cat ||
            (cat == best_cat && info.last_access_time < best_time)) {
            best = p;
            best_cat = cat;
            best_time = info.last_access_time;
        }
    }
    return best;
}

void evict_page(int victim_page_id) {
    PageInfo info = sim_get_page_info(victim_page_id);

    if (info.type == PAGE_ANON) {
        int slot = info.swap_slot;
        if (slot == -1)
            slot = sim_alloc_swap_slot();
        sim_write_to_swap(info.frame_id, slot);
        sim_set_swap_slot(victim_page_id, slot);
    } else if (info.dirty) {
        sim_write_to_file(info.frame_id, info.file_id, info.file_offset);
    }

    sim_mark_page_evicted(victim_page_id);
}

void load_page(int page_id, int frame_id) {
    PageInfo info = sim_get_page_info(page_id);

    if (info.type == PAGE_ANON) {
        if (info.swap_slot != -1) {
            sim_read_from_swap(frame_id, info.swap_slot);
            sim_free_swap_slot(info.swap_slot);
        } else {
            sim_zero_fill_frame(frame_id);
        }
    } else {
        sim_read_from_file(frame_id, info.file_id, info.file_offset);
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
