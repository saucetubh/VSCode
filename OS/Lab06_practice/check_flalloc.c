#ifndef ALLOCATOR_SOURCE
#define ALLOCATOR_SOURCE "flalloc.c"
#endif
#define main demo_main
#include ALLOCATOR_SOURCE
#undef main

#define CHECK(condition) do { \
    if (!(condition)) { \
        fprintf(stderr, "  Line %d: %s\n", __LINE__, #condition); \
        return 0; \
    } \
} while (0)

static void reset_heap(void) {
    memset(heap, 0, HEAP_SIZE);
    heap_init();
}
static size_t off_of(void *p) { return (size_t)((unsigned char *)p - heap); }

// Tiling, no adjacent free chunks, free list sorted and consistent with heap.
static int invariants(void) {
    int off = 0, prev_free = 0, free_chunks = 0;
    while (off < HEAP_SIZE) {
        node_t *c = (node_t *)(heap + off);
        CHECK(c->size >= MIN_PAYLOAD);
        CHECK(off + (int)HDR + c->size <= HEAP_SIZE);
        int is_free = c->magic != MAGIC;
        CHECK(!(is_free && prev_free));          // adjacent free chunks must be merged
        free_chunks += is_free;
        prev_free = is_free;
        off += (int)HDR + c->size;
    }
    CHECK(off == HEAP_SIZE);
    int listed = 0;
    node_t *last = NULL;
    for (node_t *c = head; c != NULL; c = c->next) {
        CHECK((unsigned char *)c >= heap && (unsigned char *)c < heap + HEAP_SIZE);
        CHECK(c->magic != MAGIC);
        CHECK(last == NULL || c > last);         // sorted by address
        last = c;
        CHECK(++listed <= HEAP_SIZE);
    }
    CHECK(listed == free_chunks);
    return 1;
}
static int fully_free(void) {
    CHECK(head == (node_t *)heap && head->size == HEAP_SIZE - (int)HDR && head->next == NULL);
    return invariants();
}

static int test_limits_and_min(void) {
    CHECK(fl_malloc(0) == NULL);
    CHECK(fl_malloc(HEAP_SIZE) == NULL);
    CHECK(fl_malloc(HEAP_SIZE - HDR + 1) == NULL);
    CHECK(fully_free());
    void *p = fl_malloc(1);                      // minimum payload is 8
    CHECK(p == heap + HDR);
    CHECK(((node_t *)heap)->size == MIN_PAYLOAD && ((node_t *)heap)->magic == MAGIC);
    CHECK(head == (node_t *)(heap + HDR + MIN_PAYLOAD));
    fl_free(p);
    CHECK(fully_free());
    return 1;
}

static int test_slide_numbers(void) {
    void *a = fl_malloc(100), *b = fl_malloc(100), *c = fl_malloc(100);
    CHECK(a == heap + 8 && b == heap + 116 && c == heap + 224);   // 108 bytes each
    CHECK(((node_t *)heap)->size == 100 && ((node_t *)heap)->magic == MAGIC);
    CHECK(head == (node_t *)(heap + 324));
    CHECK(head->size == 3764 && head->next == NULL);
    CHECK(invariants());
    fl_free(b);                                   // middle chunk only
    CHECK(head == (node_t *)(heap + 108) && head->size == 100);
    CHECK(head->next == (node_t *)(heap + 324) && head->next->size == 3764);
    CHECK(fl_malloc(3800) == NULL);               // external fragmentation
    CHECK(invariants());
    void *big = fl_malloc(3764);                  // exact fit of the tail chunk
    CHECK(big == heap + 332);
    CHECK(head == (node_t *)(heap + 108) && head->next == NULL);
    void *again = fl_malloc(100);                 // reuses the freed middle chunk exactly
    CHECK(again == b);
    CHECK(head == NULL);
    return 1;
}

static int test_split_threshold(void) {
    void *p = fl_malloc(HEAP_SIZE - HDR - (HDR + MIN_PAYLOAD));   // 4072: leaves 16 -> split
    CHECK(p == heap + 8 && ((node_t *)heap)->size == 4072);
    CHECK(head == (node_t *)(heap + 4080) && head->size == 8 && head->next == NULL);
    fl_free(p);
    CHECK(fully_free());
    p = fl_malloc(HEAP_SIZE - HDR - (HDR + MIN_PAYLOAD) + 1);     // 4073: remainder too small
    CHECK(p == heap + 8);
    CHECK(((node_t *)heap)->size == HEAP_SIZE - (int)HDR);        // whole chunk handed over
    CHECK(head == NULL);
    CHECK(invariants());
    fl_free(p);
    CHECK(fully_free());
    return 1;
}

static int test_first_fit(void) {
    void *a = fl_malloc(200), *b = fl_malloc(10), *c = fl_malloc(60), *d = fl_malloc(10);
    CHECK(a && b && c && d);
    fl_free(a);
    fl_free(c);
    CHECK(head == (node_t *)heap && head->size == 200);
    CHECK(head->next == (node_t *)(heap + 226) && head->next->size == 60);
    void *p = fl_malloc(50);                      // first fit: the 200 hole, not the 60 hole
    CHECK(p == heap + 8);
    CHECK(head == (node_t *)(heap + 58) && head->size == 142);   // remainder replaces it in the list
    CHECK(head->next == (node_t *)(heap + 226));
    CHECK(invariants());
    return 1;
}

static int test_coalesce_orders(void) {
    static const int perms[6][3] = {{0,1,2},{0,2,1},{1,0,2},{1,2,0},{2,0,1},{2,1,0}};
    for (int t = 0; t < 6; t++) {
        reset_heap();
        void *p[3] = {fl_malloc(100), fl_malloc(200), fl_malloc(300)};
        CHECK(p[0] && p[1] && p[2]);
        for (int i = 0; i < 3; i++) {
            fl_free(p[perms[t][i]]);
            CHECK(invariants());
        }
        CHECK(fully_free());
    }
    return 1;
}

static int test_merge_directions(void) {
    reset_heap();
    void *a = fl_malloc(100), *b = fl_malloc(100), *c = fl_malloc(100), *d = fl_malloc(100);
    node_t *tail = (node_t *)(heap + 432);        // leftover free chunk after 4 allocations
    CHECK(head == tail && tail->size == HEAP_SIZE - HDR - 4 * (100 + (int)HDR) && tail->next == NULL);
    fl_free(a);                                   // hole 0
    fl_free(c);                                   // hole 216, not adjacent to a
    CHECK(head == (node_t *)heap && head->size == 100);
    CHECK(head->next == (node_t *)(heap + 216) && head->next->size == 100);
    CHECK(head->next->next == tail);
    fl_free(b);                                   // bridges a and c: merge both sides
    CHECK(head == (node_t *)heap && head->size == 100 + 8 + 100 + 8 + 100);
    CHECK(head->next == tail);                    // d still allocated, tail chunk untouched
    CHECK(invariants());
    fl_free(d);                                   // now d joins the merged block and the tail
    CHECK(fully_free());
    return 1;
}

static int test_invalid_and_double_free(void) {
    reset_heap();
    void *a = fl_malloc(100), *b = fl_malloc(100);
    CHECK(a != NULL && b != NULL);
    memset(a, 0x5a, 100);
    memset(b, 0x5a, 100);
    fl_free(NULL);
    fl_free(heap);                                // header address, not a payload pointer
    fl_free((unsigned char *)a + 1);              // middle of an allocation
    fl_free(heap + HEAP_SIZE);
    fl_free((void *)&a);                          // outside the heap
    CHECK(invariants());
    CHECK(((node_t *)heap)->magic == MAGIC);      // a is still allocated
    fl_free(a);
    fl_free(a);                                   // double free must be ignored
    CHECK(invariants());
    CHECK(head == (node_t *)heap && head->size == 100 && head->next == (node_t *)(heap + 216));
    void *x = fl_malloc(100);
    CHECK(x == a);                                // list not corrupted by the second free
    void *y = fl_malloc(100);
    CHECK(y != NULL && y != a && y != b);
    fl_free(b);
    fl_free(x);
    fl_free(y);
    CHECK(fully_free());
    return 1;
}

static int test_random_stress(void) {
    reset_heap();
    void *ptr[24] = {0};
    size_t len[24] = {0};
    unsigned seed = 12345;
    for (int step = 0; step < 4000; step++) {
        seed = seed * 1103515245u + 12345u;
        int slot = (seed >> 16) % 24;
        if (ptr[slot] == NULL) {
            size_t n = 1 + ((seed >> 8) % 300);
            void *p = fl_malloc(n);
            if (p != NULL) {
                CHECK(off_of(p) >= HDR && off_of(p) + n <= HEAP_SIZE);
                ptr[slot] = p;  len[slot] = n;
                memset(p, slot + 1, n);           // unique fill per slot
            }
        } else {
            for (size_t i = 0; i < len[slot]; i++)
                CHECK(((unsigned char *)ptr[slot])[i] == slot + 1);   // data survived
            fl_free(ptr[slot]);
            ptr[slot] = NULL;
        }
        CHECK(invariants());
    }
    for (int i = 0; i < 24; i++) {
        if (ptr[i] == NULL) continue;
        for (size_t k = 0; k < len[i]; k++)
            CHECK(((unsigned char *)ptr[i])[k] == i + 1);
        fl_free(ptr[i]);
    }
    CHECK(fully_free());
    return 1;
}

int main(void) {
    static const struct { const char *name; int (*run)(void); } tests[] = {
        {"limits and minimum payload", test_limits_and_min},
        {"slide numbers (108, 3764, 3800 fails)", test_slide_numbers},
        {"split threshold and whole-chunk handoff", test_split_threshold},
        {"first fit picks the earliest chunk", test_first_fit},
        {"coalescing in every free order", test_coalesce_orders},
        {"merging both neighbours at once", test_merge_directions},
        {"invalid pointers and double free", test_invalid_and_double_free},
        {"random stress: data and invariants", test_random_stress},
    };
    int passed = 0, total = (int)(sizeof(tests) / sizeof(tests[0]));
    heap = mmap(NULL, HEAP_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (heap == MAP_FAILED) { perror("mmap"); return 1; }
    for (int i = 0; i < total; i++) {
        reset_heap();
        int ok = tests[i].run();
        printf("%s: %s\n", ok ? "PASS" : "FAIL", tests[i].name);
        passed += ok;
    }
    printf("%d/%d checks passed\n", passed, total);
    return passed == total ? 0 : 1;
}
