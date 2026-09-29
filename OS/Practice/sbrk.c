#include <stdio.h>
#include <unistd.h>
#include <stdint.h>

int main() {
    // 1. Get the current starting position of the program break
    void *initial_break = sbrk(0);
    printf("Initial program break address: %p\n", initial_break);

    // 2. Allocate space for 3 integers (3 * 4 bytes = 12 bytes)
    // sbrk(12) moves the break forward by 12 bytes and returns the OLD break.
    int *my_array = (int *)sbrk(3 * sizeof(int)); //typecasting void * to int *

    if (my_array == (void *)-1) {
        perror("sbrk allocation failed");
        return 1;
    }

    // Check where the break moved to
    void *after_alloc_break = sbrk(0);
    printf("Program break after allocating 12 bytes: %p\n", after_alloc_break);
    printf("Difference in bytes: %ld\n", (char *)after_alloc_break - (char *)initial_break);

    // 3. Use the allocated memory
    // Because this is fresh memory from sbrk, these are guaranteed to be 0 initially
    printf("\nInitial values in memory (should be 0):\n");
    for (int i = 0; i < 3; i++) {
        printf("my_array[%d] = %d\n", i, my_array[i]);
    }

    // Now write data into it
    my_array[0] = 100;
    my_array[1] = 200;
    my_array[2] = 300;

    printf("\nModified values in memory:\n");
    for (int i = 0; i < 3; i++) {
        printf("my_array[%d] = %d\n", i, my_array[i]);
    }

    // 4. Deallocate the memory by moving the break backward
    // Passing a negative number shrinks the heap
    printf("\nShrinking the heap back down...\n");
    sbrk(-(3 * sizeof(int)));

    // Verify the break returned to its initial position
    void *final_break = sbrk(0);
    printf("Final program break address: %p\n", final_break);

    return 0;
}
