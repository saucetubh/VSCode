/*
 * VARIANT A: same buckets, different priority order (or different buckets).
 *
 * Example spec: "prefer file-backed pages (cheap to drop) over anonymous ones":
 *   1. file clean   2. anon clean   3. file dirty   4. anon dirty
 * Within a bucket: LRU, ties -> smaller page_id.
 *
 * Only the rank() function changes. Every other line stays identical, which is
 * why writing the practice solution as "rank + key" is worth it.
 * evict_page / load_page are unchanged from the practice solution.
 */
#include "paging_sim.h"

static int rank(PageInfo info) {
    if (info.type == PAGE_FILE && !info.dirty) return 1;
    if (info.type == PAGE_ANON && !info.dirty) return 2;
    if (info.type == PAGE_FILE)                return 3;
    return 4;                                  /* anon dirty */
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
