#ifndef ALLOCATOR_SOURCE
#define ALLOCATOR_SOURCE "buddy.c"
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

static void reset_arena(void) {
    memset(arena, 0, ARENA_SIZE);
    memset(blocks, 0, sizeof(blocks));
    blocks[0] = (Block){ARENA_SIZE, 1};
}

static int fully_free(void) {
    CHECK(blocks[0].size == ARENA_SIZE && blocks[0].free);
    for (int i = 1; i < SLOT_COUNT; i++)
        CHECK(blocks[i].size == 0);
    return 1;
}

static int test_rounding(void) {
    const size_t requests[] = {1, 63, 64, 65, 127, 128, 129, 255, 256,
                               257, 511, 512, 513, 1023, 1024};
    const size_t expected[] = {64, 64, 64, 128, 128, 128, 256, 256, 256,
                               512, 512, 512, 1024, 1024, 1024};
    CHECK(my_malloc(0) == NULL);
    CHECK(my_malloc(1025) == NULL);
    CHECK(my_malloc(SIZE_MAX) == NULL);
    CHECK(fully_free());
    for (size_t i = 0; i < sizeof(requests) / sizeof(requests[0]); i++) {
        reset_arena();
        void *ptr = my_malloc(requests[i]);
        CHECK(ptr == arena);
        CHECK(blocks[0].size == expected[i] && !blocks[0].free);
        memset(ptr, 0x5a, requests[i]);
        my_free(ptr);
        CHECK(fully_free());
    }
    return 1;
}

static int test_splitting(void) {
    CHECK(my_malloc(100) == arena);
    CHECK(blocks[0].size == 128 && !blocks[0].free);
    CHECK(blocks[2].size == 128 && blocks[2].free);
    CHECK(blocks[4].size == 256 && blocks[4].free);
    CHECK(blocks[8].size == 512 && blocks[8].free);
    CHECK(my_malloc(100) == arena + 128);
    CHECK(my_malloc(200) == arena + 256);
    CHECK(my_malloc(500) == arena + 512);
    CHECK(my_malloc(1) == NULL);
    return 1;
}

static int test_selection(void) {
    CHECK(my_malloc(512) == arena);
    CHECK(my_malloc(128) == arena + 512);
    CHECK(my_malloc(128) == arena + 640);
    my_free(arena);
    my_free(arena + 512);
    CHECK(my_malloc(64) == arena + 512);
    CHECK(my_malloc(64) == arena + 576);

    reset_arena();
    for (int i = 0; i < 4; i++)
        CHECK(my_malloc(256) == arena + i * 256);
    my_free(arena);
    my_free(arena + 512);
    CHECK(my_malloc(128) == arena);
    return 1;
}

static int test_capacity_and_data(void) {
    unsigned char *ptrs[SLOT_COUNT];
    for (int i = 0; i < SLOT_COUNT; i++) {
        ptrs[i] = my_malloc(MIN_BLOCK);
        CHECK(ptrs[i] == arena + i * MIN_BLOCK);
        memset(ptrs[i], i + 1, MIN_BLOCK);
    }
    CHECK(my_malloc(1) == NULL);
    for (int i = 0; i < SLOT_COUNT; i += 2)
        my_free(ptrs[i]);
    CHECK(my_malloc(128) == NULL);
    for (int i = 0; i < SLOT_COUNT; i += 2) {
        ptrs[i] = my_malloc(MIN_BLOCK);
        CHECK(ptrs[i] == arena + i * MIN_BLOCK);
        memset(ptrs[i], i + 1, MIN_BLOCK);
    }
    for (int i = 0; i < SLOT_COUNT; i++)
        for (int j = 0; j < MIN_BLOCK; j++)
            CHECK(ptrs[i][j] == i + 1);
    for (int i = SLOT_COUNT - 1; i >= 0; i--)
        my_free(ptrs[i]);
    CHECK(fully_free());
    CHECK(my_malloc(ARENA_SIZE) == arena);
    return 1;
}

static int test_merge_directions(void) {
    for (int right_first = 0; right_first < 2; right_first++) {
        reset_arena();
        void *ptrs[2];
        ptrs[0] = my_malloc(1);
        ptrs[1] = my_malloc(1);
        CHECK(ptrs[0] == arena && ptrs[1] == arena + MIN_BLOCK);
        my_free(ptrs[right_first]);
        my_free(ptrs[1 - right_first]);
        CHECK(fully_free());
        CHECK(my_malloc(ARENA_SIZE) == arena);
    }
    return 1;
}

static int test_non_buddies(void) {
    for (int i = 0; i < 4; i++)
        CHECK(my_malloc(256) == arena + i * 256);
    my_free(arena + 256);
    my_free(arena + 512);
    CHECK(my_malloc(512) == NULL);
    CHECK(blocks[4].size == 256 && blocks[8].size == 256);
    my_free(arena);
    CHECK(my_malloc(512) == arena);
    my_free(arena + 768);
    my_free(arena);
    CHECK(fully_free());
    return 1;
}

static int test_mixed_sizes(void) {
    CHECK(my_malloc(400) == arena);
    CHECK(my_malloc(64) == arena + 512);
    CHECK(my_malloc(64) == arena + 576);
    CHECK(my_malloc(65) == arena + 640);
    CHECK(my_malloc(129) == arena + 768);
    CHECK(my_malloc(1) == NULL);
    my_free(arena + 640);
    my_free(arena + 512);
    my_free(arena);
    my_free(arena + 768);
    my_free(arena + 576);
    CHECK(fully_free());
    return 1;
}

static int test_invalid_free(void) {
    int outside = 0;
    CHECK(my_malloc(100) == arena);
    Block before[SLOT_COUNT];
    memcpy(before, blocks, sizeof(blocks));
    my_free(NULL);
    my_free(&outside);
    my_free(arena + 1);
    my_free(arena + MIN_BLOCK);
    my_free(arena + ARENA_SIZE);
    for (int i = 0; i < SLOT_COUNT; i++)
        CHECK(blocks[i].size == before[i].size && blocks[i].free == before[i].free);
    my_free(arena);
    my_free(arena);
    CHECK(fully_free());
    return 1;
}

int main(void) {
    const struct { const char *name; int (*run)(void); } tests[] = {
        {"request rounding and bounds", test_rounding},
        {"splitting and offsets", test_splitting},
        {"smallest block and tie breaking", test_selection},
        {"capacity, reuse, and data preservation", test_capacity_and_data},
        {"coalescing in both directions", test_merge_directions},
        {"adjacent non-buddies", test_non_buddies},
        {"mixed-size, out-of-order frees", test_mixed_sizes},
        {"invalid and double frees", test_invalid_free}
    };
    arena = mmap(NULL, ARENA_SIZE, PROT_READ | PROT_WRITE,
                 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (arena == MAP_FAILED) {
        perror("mmap");
        return 1;
    }
    int passed = 0;
    int total = (int)(sizeof(tests) / sizeof(tests[0]));
    for (int i = 0; i < total; i++) {
        reset_arena();
        int ok = tests[i].run();
        printf("%s: %s\n", ok ? "PASS" : "FAIL", tests[i].name);
        passed += ok;
    }
    printf("%d/%d checks passed\n", passed, total);
    if (munmap(arena, ARENA_SIZE) == -1) {
        perror("munmap");
        return 1;
    }
    return passed == total ? 0 : 1;
}
