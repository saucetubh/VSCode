// Buddy allocator and command-file driver for a single mmap-backed arena.
#define _DEFAULT_SOURCE
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>

// Do not modify these constants.
#define ARENA_SIZE 1024
#define MIN_BLOCK 64
#define SLOT_COUNT (ARENA_SIZE / MIN_BLOCK)
#define MAX_IDS 100

typedef struct {
    size_t size;                 // Zero means no block starts at this slot.
    int free;                    // Meaningful only when size is nonzero.
} Block;

static unsigned char *arena;
// Slot i describes a block starting at byte offset i * MIN_BLOCK.
// Metadata lives outside the arena, so all arena bytes can hold user data.
static Block blocks[SLOT_COUNT];

// Round a valid request up to a supported power-of-two block size.
static size_t round_size(size_t requested) {
    if (requested == 0 || requested > ARENA_SIZE)
        return 0;
    size_t size = MIN_BLOCK;
    while (size < requested)
        size *= 2;
    return size;
}

// Prefer the smallest suitable free block; break ties by lowest offset.
static int find_free_block(size_t needed) {
    int best = -1;
    for (int i = 0; i < SLOT_COUNT; i++)
        if (blocks[i].free && blocks[i].size >= needed &&
            (best == -1 || blocks[i].size < blocks[best].size))
            best = i;
    return best;
}

// Accept only the start of a currently allocated block in our arena.
static int allocated_index(void *ptr) {
    uintptr_t address = (uintptr_t)ptr, base = (uintptr_t)arena;
    if (ptr == NULL || address < base || address - base >= ARENA_SIZE)
        return -1;
    size_t offset = address - base;
    if (offset % MIN_BLOCK != 0)
        return -1;
    int index = (int)(offset / MIN_BLOCK); //the slot number in blocks[]
    return blocks[index].size != 0 && !blocks[index].free ? index : -1;
}

// Allocate from the arena; return NULL when the request cannot be satisfied.
void *my_malloc(size_t requested) {
    size_t needed = round_size(requested);
    if (needed == 0)
        return NULL;
    int index = find_free_block(needed);
    if (index == -1)
        return NULL;

    // TODO: Split the chosen block in half until its size equals needed.
    //       Keep the left half at index; record each right half as a free block.
    while(blocks[index].size > needed) {
        size_t half_size = blocks[index].size/2;
        blocks[index].size = half_size;
        int buddy_index = index + (int)(half_size/MIN_BLOCK);
        blocks[buddy_index] = (Block){half_size, 1};
    }
    // TODO: Mark the final block used and return its address in arena.
    blocks[index].free = 0;
    return arena+(index*MIN_BLOCK); //need to return the address in arena, which will be the address of arena + offset. Each slot is 64bytes, offset = slot * 64
}

// Free one allocation and repeatedly combine it with a free, same-size buddy.
void my_free(void *ptr) {
    int index = allocated_index(ptr);
    if (index == -1)
        return;

    // TODO: Mark this block free.
    blocks[index].free = 1;
    // TODO: Find this block's buddy using its size and position.
    //       Merge only when the buddy is free and has the same size.
    //       Keep the combined block at the lower slot; clear the higher slot.
    //       Repeat until no merge is possible.
    while(blocks[index].size < ARENA_SIZE) {
        size_t size = blocks[index].size;
        int buddy_index;
        int slots_per_block = (int) size/MIN_BLOCK;
        int block_no = index/slots_per_block;
        if(block_no % 2 == 0) { //left block
            buddy_index = index + slots_per_block;
        }
        else { //right block
            buddy_index = index - slots_per_block;
        }
        if(blocks[buddy_index].free == 0 || blocks[buddy_index].size != size) {
            break;
        }         
        int left = (index<buddy_index)? index : buddy_index;
        int right = (index>buddy_index)? index : buddy_index;
        blocks[left].size = size*2;
        blocks[right].size = 0;
        blocks[left].free = 1;
        index = left;
    }
}

// Show block boundaries, including holes
static void show_blocks(void) {
    printf("Offset  Size  State\n");
    for (int i = 0; i < SLOT_COUNT; i++)
        if (blocks[i].size != 0)
            printf("%6d  %4zu  %s\n", i * MIN_BLOCK, blocks[i].size,
                   blocks[i].free ? "FREE" : "USED");
}

// Map the arena, run a command file, then unmap it.
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
    // TODO: Call mmap() to reserve ARENA_SIZE bytes and store its result in arena.
    //       Let the OS choose the address (pass NULL).
    //       Allow both reading and writing to the mapped memory.
    //       Use a private, anonymous mapping: it is not backed by a file.
    //       Pass -1 as the file descriptor and 0 as the offset.
    arena = mmap(NULL, ARENA_SIZE, PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);  // Replace this placeholder with your mmap() call.
    if (arena == MAP_FAILED) {
        fprintf(stderr, "Arena mapping failed. Complete or check the mmap() TODO.\n");
        fclose(input);
        return 1;
    }
    blocks[0] = (Block){ARENA_SIZE, 1};

    void *allocations[MAX_IDS + 1] = {0};
    size_t next_id = 1, value;
    char command[16];
    int result = 0;
    while (fscanf(input, "%15s", command) == 1) {
        if (strcmp(command, "show") == 0) {
            show_blocks();
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
            void *ptr = my_malloc(value);
            if (ptr == NULL) {
                printf("alloc %zu -> FAILED\n", value);
                continue;
            }
            allocations[next_id] = ptr;
            printf("alloc %zu -> id %zu, offset %zu, size %zu\n", value,
                   next_id++, (size_t)((unsigned char *)ptr - arena),
                   round_size(value));
        } else if (value == 0 || value >= next_id || allocations[value] == NULL) {
            printf("free %zu -> INVALID ID\n", value);
        } else {
            my_free(allocations[value]);
            allocations[value] = NULL;
            printf("free %zu -> OK\n", value);
        }
    }
    fclose(input);
    if (munmap(arena, ARENA_SIZE) == -1) {
        perror("munmap");
        result = 1;
    }
    return result;
}
