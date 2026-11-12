/*
 * VARIANT G: changes to the eviction/loading mechanics rather than the victim
 * policy. select_victim_page stays the same as the practice solution.
 *
 * G1. Minor vs major fault counters (the README defines these; slide 25 shows
 *     ru_minflt / ru_majflt):
 *       zero-fill first touch        -> MINOR (no disk I/O)
 *       swap-in or file read         -> MAJOR (disk I/O)
 *     Count in load_page, because that is where you know which path ran.
 *
 * G2. "Swap cache": keep the swap copy of a clean anon page. If an anon page was
 *     swapped in and NOT modified, its swap slot still holds identical bytes,
 *     so evicting it again needs no SWAP OUT.
 *       load: read from swap, but DON'T free the slot
 *       evict anon: if (swap_slot != -1 && !dirty) skip the write
 *                   if dirty, write it (reuse the slot it already owns)
 *     This only works if the framework's sim_mark_page_loaded does NOT reset
 *     swap_slot to -1. The practice framework does reset it, so read the
 *     eval's sim_framework.c before coding this.
 */
#include "paging_sim.h"

int minor_faults = 0;
int major_faults = 0;

void evict_page(int victim_page_id) {
    PageInfo info = sim_get_page_info(victim_page_id);

    if (info.type == PAGE_ANON) {
        int slot = info.swap_slot;
        if (slot == -1) {
            slot = sim_alloc_swap_slot();
            sim_write_to_swap(info.frame_id, slot);
        } else if (info.dirty) {
            sim_write_to_swap(info.frame_id, slot);   /* G2: reuse own slot */
        }                                             /* G2: clean + slot -> skip */
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
            /* G2: no sim_free_swap_slot here; the copy stays valid while clean */
            major_faults++;
        } else {
            sim_zero_fill_frame(frame_id);
            minor_faults++;
        }
    } else {
        sim_read_from_file(frame_id, info.file_id, info.file_offset);
        major_faults++;
    }

    sim_mark_page_loaded(page_id, frame_id);
}
