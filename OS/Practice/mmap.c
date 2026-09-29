/*
#include <stdio.h>
#include <sys/mman.h>
#include <unistd.h>

int main() {
    size_t size = 4096; // Request 1 page of memory (usually 4KB)

    // Allocate raw, zero-initialized memory from the OS
    int *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    if (ptr == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }

    // Use the memory like a normal array
    ptr[0] = 42;
    ptr[1] = 100;
    printf("Anonymous memory values: %d, %d\n", ptr[0], ptr[1]);

    // Free the specific block immediately back to the OS
    if (munmap(ptr, size) == -1) {
        perror("munmap failed");
        return 1;
    }

    return 0;
}
*/
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <string.h>

int main() {
    // 1. Open (or create) a file for reading and writing
    int fd = open("example.txt", O_RDWR | O_CREAT, 0666);
    if (fd == -1) { perror("open failed"); return 1; }

    // Ensure the file is at least 100 bytes big so we can write to it
    ftruncate(fd, 100);

    // 2. Map the file directly to a memory pointer
    // MAP_SHARED means changes to this pointer are written back to the file
    //to force flush to disk, we can use msync()
    char *file_memory = mmap(NULL, 100, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    
    if (file_memory == MAP_FAILED) {
        perror("mmap failed");
        close(fd);
        return 1;
    }

    // 3. We can close the file descriptor immediately; the mapping stays alive!
    close(fd);

    // 4. Manipulate the file directly using standard string functions
    strcpy(file_memory, "Hello, mmap file-backed memory!"); //can also use snprintf(file_memory, 100, "String%d",num);
    printf("File contents read via memory pointer: %s\n", file_memory);

    // 5. Clean up and sync changes to disk
    munmap(file_memory, 100);

    return 0;
}
