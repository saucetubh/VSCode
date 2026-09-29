#ifndef RW_SOURCE
#define RW_SOURCE "rw.c"
#endif
#define main demo_main
#include RW_SOURCE
#undef main

#include <stdio.h>

#define CHECK(condition) do { \
    if (!(condition)) { \
        fprintf(stderr, "  Line %d: %s\n", __LINE__, #condition); \
        return 0; \
    } \
} while (0)

static unsigned char *open_file_map(void) {
    int fd = open(SHARED_FILE, O_RDONLY);
    if (fd == -1) return MAP_FAILED;
    unsigned char *m = mmap(NULL, REGION_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
    close(fd);
    return m;
}

static int check_file_contents(unsigned char *map) {
    Header *h = (Header *)map;
    CHECK(h->records_written == NUM_WRITERS);
    for (int i = 0; i < NUM_WRITERS; i++) {
        Record *r = (Record *)(map + RECORD_SIZE + i * RECORD_SIZE);
        CHECK(r->writer_id == i);
        CHECK(r->message[0] != '\0');
    }
    return 1;
}

static int test_writes(void) {
    run_writers();
    unsigned char *map = open_file_map();
    CHECK(map != MAP_FAILED);
    int ok = check_file_contents(map);
    munmap(map, REGION_SIZE);
    return ok;
}

static int test_reader_output(void) {
    run_writers();

    unsigned char *map = open_file_map();
    CHECK(map != MAP_FAILED);
    uint32_t count = ((Header *)map)->records_written;
    munmap(map, REGION_SIZE);
    if (count != NUM_WRITERS) {
        fprintf(stderr, "  Writers did not finish (records_written = %u); skipping "
                        "the reader so it cannot wait forever. Fix the writer side first.\n",
                count);
        return 0;
    }

    FILE *capture = tmpfile();
    CHECK(capture != NULL);
    fflush(stdout);
    int saved = dup(STDOUT_FILENO);
    dup2(fileno(capture), STDOUT_FILENO);
    run_reader();
    fflush(stdout);
    dup2(saved, STDOUT_FILENO);
    close(saved);

    rewind(capture);
    int found_header = 0, found_writers = 0;
    char line[256];
    while (fgets(line, sizeof(line), capture)) {
        unsigned rw_count;
        if (sscanf(line, "records_written: %u", &rw_count) == 1) {
            CHECK(rw_count == NUM_WRITERS);
            found_header = 1;
        }
        int wid;
        char msg[RECORD_SIZE];
        if (sscanf(line, "writer %d: %59[^\n]", &wid, msg) == 2) {
            CHECK(wid >= 0 && wid < NUM_WRITERS);
            CHECK(msg[0] != '\0');
            found_writers++;
        }
    }
    fclose(capture);
    CHECK(found_header);
    CHECK(found_writers == NUM_WRITERS);
    return 1;
}

static int test_stress(void) {
    for (int iter = 0; iter < 10; iter++) {
        unlink(SHARED_FILE);
        run_writers();
        unsigned char *map = open_file_map();
        CHECK(map != MAP_FAILED);
        int ok = check_file_contents(map);
        munmap(map, REGION_SIZE);
        if (!ok) return 0;
    }
    return 1;
}

int main(void) {
    const struct { const char *name; int (*run)(void); } tests[] = {
        {"writer threads and header integrity", test_writes},
        {"reader output format and content",    test_reader_output},
        {"repeated writes (stress)",            test_stress},
    };
    int passed = 0;
    int total  = (int)(sizeof(tests) / sizeof(tests[0]));
    for (int i = 0; i < total; i++) {
        unlink(SHARED_FILE);
        int ok = tests[i].run();
        printf("%s: %s\n", ok ? "PASS" : "FAIL", tests[i].name);
        passed += ok;
    }
    printf("%d/%d checks passed\n", passed, total);
    unlink(SHARED_FILE);
    return passed == total ? 0 : 1;
}
