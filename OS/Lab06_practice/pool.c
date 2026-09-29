// Fixed-size pool allocator (embedded free list of slots) and command-file
// driver. The pool's memory comes from sbrk(), not mmap().
#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

// Do not modify these constants.
#define POOL_SLOTS 16
#define SLOT_SIZE  32
#define POOL_BYTES (POOL_SLOTS * SLOT_SIZE)   // 512
#define MAX_IDS    100

static unsigned char *pool;              // start of the pool (from sbrk)
static void *free_head;                  // first free slot, or NULL when full
static unsigned char used[POOL_SLOTS];   // 1 while slot i is allocated

// While a slot is FREE, its first bytes hold a pointer to the next free slot
// (or NULL). No separate list nodes are needed: the free list is embedded.
static void *get_next(void *slot)            { return *(void **)slot; }
static void  set_next(void *slot, void *nxt) { *(void **)slot = nxt; }

// Return the slot number if ptr is exactly the start of a slot inside the
// pool, otherwise -1.
static int slot_index(void *ptr) {
    uintptr_t a = (uintptr_t)ptr, base = (uintptr_t)pool;
    if (ptr == NULL || a < base || a - base >= POOL_BYTES)
        return -1;
    if ((a - base) % SLOT_SIZE != 0)
        return -1;
    return (int)((a - base) / SLOT_SIZE);
}

// Thread all slots onto the free list in address order:
// slot 0 -> slot 1 -> ... -> slot 15 -> NULL. Nothing is in use.
void pool_init(void) {
    // TODO: clear used[], link every slot to the next one (use set_next),
    //       and point free_head at slot 0.
    
}

// Take one slot from the front of the free list; NULL if the pool is full.
void *pool_alloc(void) {
    // TODO: pop free_head, mark its slot used, return it.
    return NULL;
}

// Return a slot to the FRONT of the free list (so the most recently freed
// slot is handed out next). Ignore anything that is not the start of a
// currently allocated slot: NULL, pointers outside the pool, pointers into
// the middle of a slot, and double frees.
void pool_free(void *ptr) {
    // TODO: validate with slot_index() and used[]; mark the slot unused;
    //       push it onto the front of the free list.
}

// Print the slot map (U = used, F = free) and the free list in list order.
static void show_pool(void) {
    printf("Slots: ");
    int used_count = 0;
    for (int i = 0; i < POOL_SLOTS; i++) {
        putchar(used[i] ? 'U' : 'F');
        used_count += used[i];
    }
    printf("\nFree list:");
    if (free_head == NULL)
        printf(" (empty)");
    int guard = 0;
    for (void *s = free_head; s != NULL && guard++ < POOL_SLOTS; s = get_next(s))
        printf(" %d", slot_index(s));
    printf("\nUsed: %d  Free: %d\n", used_count, POOL_SLOTS - used_count);
}

// Get the pool from sbrk, run a command file, then give the memory back.
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
    // TODO: Call sbrk() to grow the heap by POOL_BYTES and store the result in pool.
    //       Remember: sbrk() returns the OLD program break, which is exactly
    //       the start of the new memory. On failure it returns (void *)-1.
    pool = sbrk(POOL_BYTES);  // Replace this placeholder with your sbrk() call.
    if ((void *)pool == (void *)-1) {
        fprintf(stderr, "Pool allocation failed. Complete or check the sbrk() TODO.\n");
        fclose(input);
        return 1;
    }
    pool_init();

    void *allocations[MAX_IDS + 1] = {0};
    size_t next_id = 1, value;
    char command[16];
    int result = 0;
    while (fscanf(input, "%15s", command) == 1) {
        if (strcmp(command, "show") == 0) {
            show_pool();
            continue;
        }
        if (strcmp(command, "alloc") == 0) {
            if (next_id > MAX_IDS) {
                fprintf(stderr, "Too many allocation IDs in this script\n");
                result = 1;
                break;
            }
            void *ptr = pool_alloc();
            if (ptr == NULL) {
                printf("alloc -> FAILED (pool full)\n");
                continue;
            }
            allocations[next_id] = ptr;
            printf("alloc -> id %zu, slot %d\n", next_id++, slot_index(ptr));
        } else if (strcmp(command, "free") == 0 && fscanf(input, "%zu", &value) == 1) {
            if (value == 0 || value >= next_id || allocations[value] == NULL) {
                printf("free %zu -> INVALID ID\n", value);
            } else {
                pool_free(allocations[value]);
                allocations[value] = NULL;
                printf("free %zu -> OK\n", value);
            }
        } else {
            fprintf(stderr, "Expected alloc, free <id>, or show\n");
            result = 1;
            break;
        }
    }
    fclose(input);
    if (sbrk(-POOL_BYTES) == (void *)-1) {
        perror("sbrk");
        result = 1;
    }
    return result;
}
