#ifndef ALLOCATOR_SOURCE
#define ALLOCATOR_SOURCE "pool.c"
#endif
#define main demo_main
#include ALLOCATOR_SOURCE
#undef main
#include <sys/mman.h>

#define CHECK(condition) do { \
    if (!(condition)) { \
        fprintf(stderr, "  Line %d: %s\n", __LINE__, #condition); \
        return 0; \
    } \
} while (0)

static unsigned char *slot(int i) { return pool + i * SLOT_SIZE; }

// Free list is acyclic, holds exactly the unused slots, and no slot twice.
static int consistent(void) {
    int seen[POOL_SLOTS] = {0}, n = 0;
    for (void *s = free_head; s != NULL; s = get_next(s)) {
        int i = slot_index(s);
        CHECK(i >= 0);
        CHECK(!seen[i] && !used[i]);
        seen[i] = 1;
        CHECK(++n <= POOL_SLOTS);
    }
    for (int i = 0; i < POOL_SLOTS; i++)
        CHECK(seen[i] == !used[i]);
    return 1;
}

static int test_init_order(void) {
    CHECK(free_head == slot(0));
    for (int i = 0; i < POOL_SLOTS; i++) {
        CHECK(!used[i]);
        CHECK(get_next(slot(i)) == (i + 1 < POOL_SLOTS ? (void *)slot(i + 1) : NULL));
    }
    return consistent();
}

static int test_alloc_all_then_full(void) {
    for (int i = 0; i < POOL_SLOTS; i++)
        CHECK(pool_alloc() == slot(i));
    CHECK(free_head == NULL);
    CHECK(pool_alloc() == NULL);
    CHECK(pool_alloc() == NULL);
    return consistent();
}

static int test_lifo_reuse(void) {
    void *a = pool_alloc(), *b = pool_alloc(), *c = pool_alloc();
    CHECK(a == slot(0) && b == slot(1) && c == slot(2));
    pool_free(b);
    CHECK(pool_alloc() == b);                     // most recently freed comes back first
    pool_free(a);
    pool_free(c);
    CHECK(free_head == c && get_next(c) == a && get_next(a) == slot(3));
    CHECK(pool_alloc() == c);
    CHECK(pool_alloc() == a);
    CHECK(pool_alloc() == slot(3));
    return consistent();
}

static int test_data_isolated(void) {
    void *p[POOL_SLOTS];
    for (int i = 0; i < POOL_SLOTS; i++) {
        p[i] = pool_alloc();
        CHECK(p[i] != NULL);
        memset(p[i], 0x40 + i, SLOT_SIZE);
    }
    pool_free(p[7]);
    for (int i = 0; i < POOL_SLOTS; i++) {
        if (i == 7) continue;
        for (int k = 0; k < SLOT_SIZE; k++)
            CHECK(((unsigned char *)p[i])[k] == 0x40 + i);
    }
    return consistent();
}

static int test_invalid_frees(void) {
    void *a = pool_alloc(), *b = pool_alloc();
    pool_free(NULL);
    pool_free(pool - SLOT_SIZE);
    pool_free(pool + POOL_BYTES);
    pool_free((unsigned char *)a + 1);            // inside a slot
    pool_free(slot(9));                           // in range but never allocated
    int local;
    pool_free(&local);
    CHECK(used[0] && used[1] && !used[9]);
    CHECK(consistent());
    pool_free(a);
    pool_free(a);                                 // double free ignored
    CHECK(consistent());
    CHECK(pool_alloc() == a);
    CHECK(pool_alloc() == slot(2));
    pool_free(b);
    CHECK(pool_alloc() == b);
    return consistent();
}

static int test_churn(void) {
    void *held[POOL_SLOTS] = {0};
    unsigned seed = 99;
    for (int step = 0; step < 2000; step++) {
        seed = seed * 1103515245u + 12345u;
        int i = (seed >> 16) % POOL_SLOTS;
        if (held[i] == NULL) held[i] = pool_alloc();
        else { pool_free(held[i]); held[i] = NULL; }
        CHECK(consistent());
    }
    int alive = 0;
    for (int i = 0; i < POOL_SLOTS; i++) alive += held[i] != NULL;
    int used_count = 0;
    for (int i = 0; i < POOL_SLOTS; i++) used_count += used[i];
    CHECK(alive == used_count);
    return 1;
}

int main(void) {
    static const struct { const char *name; int (*run)(void); } tests[] = {
        {"initial free list order", test_init_order},
        {"allocate every slot, then pool is full", test_alloc_all_then_full},
        {"freed slot is reused first (LIFO)", test_lifo_reuse},
        {"slot data stays isolated", test_data_isolated},
        {"invalid pointers and double free", test_invalid_frees},
        {"random churn keeps the list consistent", test_churn},
    };
    int passed = 0, total = (int)(sizeof(tests) / sizeof(tests[0]));
    pool = mmap(NULL, POOL_BYTES, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (pool == MAP_FAILED) { perror("mmap"); return 1; }
    for (int i = 0; i < total; i++) {
        memset(pool, 0, POOL_BYTES);
        pool_init();
        int ok = tests[i].run();
        printf("%s: %s\n", ok ? "PASS" : "FAIL", tests[i].name);
        passed += ok;
    }
    printf("%d/%d checks passed\n", passed, total);
    return passed == total ? 0 : 1;
}
