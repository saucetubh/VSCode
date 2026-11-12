/*
 * VARIANT C: MRU (evict the MOST recently used page), inside the four buckets.
 *
 * The comparison flips to ">", but the page_id tie-break stays "smaller wins".
 * With an ascending scan and strict ">", the first (smaller) page_id is kept on
 * a tie, so no extra code is needed. Read the spec's tie rule carefully. If it
 * says "larger page_id wins ties", use ">=" (or scan downwards).
 */
#include "paging_sim.h"

static int rank(PageInfo info) {
    if (info.type == PAGE_ANON && !info.dirty) return 1;
    if (info.type == PAGE_FILE && !info.dirty) return 2;
    if (info.type == PAGE_ANON)                return 3;
    return 4;
}

int select_victim_page(void) {
    int best = -1;
    int best_rank = 0;
    uint64_t best_time = 0;

    for (int p = 0; p < sim_page_count(); p++) {
        PageInfo info = sim_get_page_info(p);
        if (!info.resident)
            continue;

        int r = rank(info);
        if (best == -1 || r < best_rank ||
            (r == best_rank && info.last_access_time > best_time)) {
            best = p;
            best_rank = r;
            best_time = info.last_access_time;
        }
    }
    return best;
}
