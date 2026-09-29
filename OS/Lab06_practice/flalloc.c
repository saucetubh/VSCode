// Free-list allocator (embedded free list, headers, split + coalesce) and
// command-file driver, all on one mmap-backed heap.
#define _DEFAULT_SOURCE
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

// Do not modify these constants.
#define HEAP_SIZE   4096
#define MAGIC       1234567
#define MIN_PAYLOAD 8          // a free chunk must have room for its `next` pointer
#define MAX_IDS     100

// One chunk = header (size, magic) followed by payload. While a chunk is FREE,
// its payload begins with the `next` pointer, so the free list lives inside
// the free chunks themselves. The struct is packed so the header is exactly
// 8 bytes (like the slides) and chunks may start at any byte offset.
typedef struct __attribute__((packed)) node {
    int size;                  // payload bytes; the 8-byte header is NOT counted
    int magic;                 // MAGIC while allocated, 0 while free
    struct node *next;         // valid only while free (lives in the payload)
} node_t;
#define HDR offsetof(node_t, next)   // 8

static unsigned char *heap;    // the whole mapped heap
static node_t *head;           // first free chunk; the list is kept sorted by address

// Start with one free chunk covering the whole heap (4096 - 8 = 4088 payload bytes).
static void heap_init(void) {
    head = (node_t *)heap;
    head->size = HEAP_SIZE - (int)HDR;
    head->magic = 0;
    head->next = NULL;
}

// Return the first free chunk (in list order) whose payload is at least `need`
// bytes, and store its predecessor (NULL if it is the head) in *prev_out.
static node_t *find_first_fit(int need, node_t **prev_out) {
    node_t *prev = NULL;
    for (node_t *c = head; c != NULL; prev = c, c = c->next) {
        if (c->size >= need) {
            *prev_out = prev;
            return c;
        }
    }
    return NULL;
}

// Accept only a pointer previously returned by fl_malloc() and not yet freed.
static node_t *chunk_from_ptr(void *ptr) {
    uintptr_t a = (uintptr_t)ptr, base = (uintptr_t)heap;
    if (ptr == NULL || a < base + HDR || a >= base + HEAP_SIZE)
        return NULL;
    node_t *chunk = (node_t *)(a - HDR);
    return chunk->magic == MAGIC ? chunk : NULL;
}

// Allocate `requested` bytes; return NULL if it cannot be satisfied.
void *fl_malloc(size_t requested) {
    if (requested == 0 || requested > HEAP_SIZE - HDR)
        return NULL;
    int need = requested < MIN_PAYLOAD ? MIN_PAYLOAD : (int)requested;
    node_t *prev;
    node_t *chunk = find_first_fit(need, &prev);
    if (chunk == NULL)
        return NULL;

    // TODO 1: If the chunk can leave a usable remainder
    //         (chunk->size >= need + HDR + MIN_PAYLOAD), SPLIT it:
    //         the remainder becomes a new free chunk placed right after the
    //         first `need` payload bytes; it takes the chunk's place in the list.
    //         Otherwise hand over the WHOLE chunk (its size stays unchanged).
    node_t *replace;
    if(chunk->size > need+(int)HDR+MIN_PAYLOAD) {
        node_t *rest = (node_t *)((unsigned char *)chunk + need + HDR);
        rest->size = chunk->size - need - (int)HDR;
        rest->magic = 0;
        rest->next = chunk->next;
        chunk->size = need;
        replace = rest;
    }
    else {
        replace = chunk->next;
    }
    if (prev == NULL)
        head = chunk->next;
    else
        prev->next = chunk->next;
    // TODO 3: Mark the chunk allocated (magic) and return a pointer to its
    //         payload, i.e. just past the header.

    return NULL;
}

// Free one allocation: put it back in the address-sorted free list and
// coalesce it with adjacent free chunks. Invalid pointers and double frees
// are ignored.
void fl_free(void *ptr) {
    node_t *chunk = chunk_from_ptr(ptr);
    if (chunk == NULL)
        return;

    // TODO 1: Mark the chunk free (clear its magic).
    // TODO 2: Find its place in the free list so the list stays sorted by
    //         address; remember the free chunks just before and after it.
    // TODO 3: Insert it. Then merge with the following chunk if they touch
    //         (chunk end == next chunk start), and with the preceding chunk
    //         if they touch. Merged size = size1 + HDR + size2.
}

// Print every chunk in address order, then the free list in list order.
static void show_heap(void) {
    printf("Offset  Payload  State\n");
    for (int off = 0; off < HEAP_SIZE;) {
        node_t *c = (node_t *)(heap + off);
        if (c->size < 0 || off + (int)HDR + c->size > HEAP_SIZE) {
            printf("heap corrupted at offset %d\n", off);
            break;
        }
        printf("%6d  %7d  %s\n", off, c->size, c->magic == MAGIC ? "USED" : "FREE");
        off += (int)HDR + c->size;
    }
    printf("Free list:");
    if (head == NULL)
        printf(" (empty)");
    for (node_t *c = head; c != NULL; c = c->next)
        printf(" [%ld:%d]", (long)((unsigned char *)c - heap), c->size);
    printf("\n");
}

// Map the heap, run a command file, then unmap it.
int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <commands.txt>\n", argv[0]);
        return 1;
    }
    FILE *input = fopen(argv[1], "r");
    if (input == NULL) {
        perror("fopen");
        return 1;
    }
    // TODO: Call mmap() to reserve HEAP_SIZE bytes and store its result in heap.
    //       Let the OS choose the address (pass NULL).
    //       Allow both reading and writing.
    //       Use a private, anonymous mapping (not backed by a file).
    //       Pass -1 as the file descriptor and 0 as the offset.
    heap = mmap(NULL, HEAP_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);  // Replace this placeholder with your mmap() call.
    if (heap == MAP_FAILED) {
        fprintf(stderr, "Heap mapping failed. Complete or check the mmap() TODO.\n");
        fclose(input);
        return 1;
    }
    heap_init();

    void *allocations[MAX_IDS + 1] = {0};
    size_t next_id = 1, value;
    char command[16];
    int result = 0;
    while (fscanf(input, "%15s", command) == 1) {
        if (strcmp(command, "show") == 0) {
            show_heap();
            continue;
        }
        if ((strcmp(command, "alloc") != 0 && strcmp(command, "free") != 0) ||
            fscanf(input, "%zu", &value) != 1) {
            fprintf(stderr, "Expected alloc <bytes>, free <id>, or show\n");
            result = 1;
            break;
        }
        if (strcmp(command, "alloc") == 0) {
            if (next_id > MAX_IDS) {
                fprintf(stderr, "Too many allocation IDs in this script\n");
                result = 1;
                break;
            }
            void *ptr = fl_malloc(value);
            if (ptr == NULL) {
                printf("alloc %zu -> FAILED\n", value);
                continue;
            }
            allocations[next_id] = ptr;
            node_t *c = (node_t *)((unsigned char *)ptr - HDR);
            printf("alloc %zu -> id %zu, chunk %zu, payload %d\n", value, next_id++,
                   (size_t)((unsigned char *)c - heap), c->size);
        } else if (value == 0 || value >= next_id || allocations[value] == NULL) {
            printf("free %zu -> INVALID ID\n", value);
        } else {
            fl_free(allocations[value]);
            allocations[value] = NULL;
            printf("free %zu -> OK\n", value);
        }
    }
    fclose(input);
    if (munmap(heap, HEAP_SIZE) == -1) {
        perror("munmap");
        result = 1;
    }
    return result;
}
