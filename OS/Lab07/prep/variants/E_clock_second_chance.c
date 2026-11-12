/*
 * VARIANT E: Clock / Second-Chance (approximate LRU, slide 23).
 *
 * ASSUMES the eval provides a reference bit (`referenced`) and a way to clear
 * it (`sim_clear_referenced`). Names may differ; the logic stays the same.
 *
 * Frames sit in a circle and a static "hand" points at one frame.
 *   - page in the frame has referenced == 1 -> clear it (second chance), advance
 *   - referenced == 0                       -> that page is the victim; the
 *                                              hand moves one past it
 * At most two full sweeps: the first clears every bit, so the second must find a
 * victim.
 *
 * The clock walks FRAMES, not pages, so you need frame -> page. There is no API
 * for that, so scan the pages for the one whose frame_id matches.
 * Check the spec for whether the hand moves past the victim (usual) or stays on
 * it. That decides the next victim.
 */
#include "paging_sim.h"

static int clock_hand = 0;

static int page_in_frame(int frame_id) {
    for (int p = 0; p < sim_page_count(); p++) {
        PageInfo info = sim_get_page_info(p);
        if (info.resident && info.frame_id == frame_id)
            return p;
    }
    return -1;
}

int select_victim_page(void) {
    for (int step = 0; step < 2 * NUM_FRAMES; step++) {
        int frame = clock_hand;
        int p = page_in_frame(frame);
        clock_hand = (clock_hand + 1) % NUM_FRAMES;

        if (p == -1)
            continue;              /* empty frame (only reachable via SELECT) */

        PageInfo info = sim_get_page_info(p);
        if (info.referenced) {
            sim_clear_referenced(p);
            continue;
        }
        return p;
    }
    return -1;                     /* no resident page at all */
}

/*
 * Enhanced second chance / NRU (also slide 23: "unused and clean first, then
 * unused dirty") is buckets again. Use the practice-lab structure with
 *     class = 2 * referenced + dirty    -> (0,0) (0,1) (1,0) (1,1)
 * and LRU / page_id inside the class. See F_nru.c.
 */
