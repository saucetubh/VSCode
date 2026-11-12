/*
 * VARIANT D: LFU (fewest accesses), ties -> LRU, then smaller page_id.
 *
 * ASSUMES the eval's PageInfo exposes a per-page access counter (here
 * `access_count`; the real name may differ). Your code can't count accesses
 * itself, because READ/WRITE never call into paging.c on a hit.
 *
 * Multi-key compare: write it as a chain of "if a != b return a < b". That is
 * the least error-prone way to do lexicographic ordering under exam pressure.
 */
#include "paging_sim.h"

/* true if page a should be evicted before page b */
static bool better_victim(PageInfo a, PageInfo b) {
    if (a.access_count != b.access_count)
        return a.access_count < b.access_count;
    if (a.last_access_time != b.last_access_time)
        return a.last_access_time < b.last_access_time;
    return a.page_id < b.page_id;
}

int select_victim_page(void) {
    int best = -1;
    PageInfo best_info;

    for (int p = 0; p < sim_page_count(); p++) {
        PageInfo info = sim_get_page_info(p);
        if (!info.resident)
            continue;
        if (best == -1 || better_victim(info, best_info)) {
            best = p;
            best_info = info;
        }
    }
    return best;
}
