/*
 * VARIANT F: NRU / Enhanced Second Chance as four buckets on (referenced, dirty):
 *   1. not referenced, clean   2. not referenced, dirty
 *   3. referenced,     clean   4. referenced,     dirty
 * Inside a bucket: LRU, then smaller page_id.
 *
 * ASSUMES a `referenced` bit in PageInfo. This is the same code as the practice
 * lab with a different rank(). If the spec also says "clear all reference bits
 * after choosing", loop over resident pages and clear them after picking.
 */
#include "paging_sim.h"

static int rank(PageInfo info) {
    return 1 + 2 * (info.referenced ? 1 : 0) + (info.dirty ? 1 : 0);
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
            (r == best_rank && info.last_access_time < best_time)) {
            best = p;
            best_rank = r;
            best_time = info.last_access_time;
        }
    }
    return best;
}
