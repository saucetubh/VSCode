// Writer and reader for a shared file-backed mmap region.
#define _DEFAULT_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

// Do not modify these constants.
#define SHARED_FILE  "shared.bin"
#define NUM_WRITERS  3
#define RECORD_SIZE  64
#define REGION_SIZE  ((1 + NUM_WRITERS) * RECORD_SIZE)

// Slot 0 of the region. records_written is shared across all writer threads.
typedef struct {
    uint32_t records_written;
    // Unused padding so the header fills a full RECORD_SIZE slot, like every record.
    char     _pad[RECORD_SIZE - sizeof(uint32_t)];
} Header;

// Slots 1 through NUM_WRITERS of the region. Slot (1 + id) belongs to writer id.
typedef struct {
    int  writer_id;
    char message[RECORD_SIZE - sizeof(int)];
} Record;

// Do not modify this declaration.
static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

// Set by run_writers() before threads are spawned. Do not modify.
static unsigned char *region;

static void *writer_thread(void *arg) {
    int id = *(int *)arg;

    // Provided: pointers to the header and to this writer's record.
    Header *header = (Header *)region;
    Record *record = (Record *)(region + RECORD_SIZE + id * RECORD_SIZE);

    // TODO: Lock the mutex.
    
    // TODO: Fill in the record: set writer_id to id and write a non-empty string to message.

    // TODO: Increment header->records_written, after filling the record.
    //       The reader treats this count as "records that are ready".

    // TODO: Unlock the mutex.

    // TODO: Call msync() on the whole region and wait for it to finish.
    //       It only flushes to disk; other processes can see your write without it.

    (void)lock; (void)header; (void)record;  // Remove this line once you use them.
    return NULL;
}

// Demo only: RW_DEMO_STAGGER_MS delays each writer so `./rw read` shows them arriving one by one.
static useconds_t demo_stagger_us(void) {
    const char *v = getenv("RW_DEMO_STAGGER_MS");
    if (!v) return 0;
    long ms = atol(v);
    return ms > 0 ? (useconds_t)(ms * 1000) : 0;
}

// Provided except for the mmap() call: open the file, size it, spawn the writers, join, unmap.
void run_writers(void) {
    int fd = open(SHARED_FILE, O_RDWR | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) { perror("open"); return; }

    // ftruncate sets the file's size. A new file is 0 bytes, so there would be nothing to map.
    if (ftruncate(fd, REGION_SIZE) == -1) { perror("ftruncate"); close(fd); return; }

    // TODO: Call mmap() to map the whole file into memory and store the result in region.
    //       Let the OS choose the address (pass NULL).
    //       Map REGION_SIZE bytes, starting at offset 0 of the file.
    //       Allow both reading and writing.
    //       Use a shared mapping, so writes reach the file and other processes can see them.
    //       The file to map is fd.
    region = MAP_FAILED;  // Replace this placeholder with your mmap() call.
    close(fd);
    if (region == MAP_FAILED) {
        fprintf(stderr, "Region mapping failed. Complete or check the mmap() TODO.\n");
        return;
    }

    pthread_t threads[NUM_WRITERS];
    int ids[NUM_WRITERS];
    useconds_t stagger = demo_stagger_us();
    for (int i = 0; i < NUM_WRITERS; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, writer_thread, &ids[i]);
        if (stagger) usleep(stagger);
    }
    for (int i = 0; i < NUM_WRITERS; i++)
        pthread_join(threads[i], NULL);

    munmap(region, REGION_SIZE);
    region = NULL;
}

// TODO: Open SHARED_FILE read-only and map it into memory.
//       Use a shared, read-only mapping of REGION_SIZE bytes from offset 0.
//
//       The writers race, so wait for them. Keep a local count, starting at 0,
//       and loop while count < NUM_WRITERS:
//         1. Set count to header->records_written.
//         2. For each writer i (0 to NUM_WRITERS - 1) not printed yet, if its
//            message is non-empty, print
//                "writer %d: %s\n"
//            and call fflush(stdout).
//         3. If count is still below NUM_WRITERS, usleep() briefly.
//       Read the count before the scan, so a writer that finishes mid-scan is not missed.
//
//       Then print "records_written: %u\n", unmap, and close.
//       If no writer ever finishes, this waits forever; press Ctrl-C.
void run_reader(void) {
}

// Provided: dispatch on argv[1]. Do not modify.
int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s write|read\n", argv[0]);
        return 1;
    }
    if (strcmp(argv[1], "write") == 0) {
        run_writers();
    } else if (strcmp(argv[1], "read") == 0) {
        run_reader();
    } else {
        fprintf(stderr, "Unknown mode: %s\n", argv[1]);
        return 1;
    }
    return 0;
}
