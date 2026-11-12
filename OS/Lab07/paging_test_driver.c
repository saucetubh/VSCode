#include "paging_sim.h"

#include <string.h>

/* The simulator provides these wrappers, but the student header focuses on
 * the paging-policy APIs.  The external test driver calls them to create
 * realistic reads and writes that trigger page faults. */
uint8_t read_virtual_memory(int page_id, size_t offset);
void write_virtual_memory(int page_id, size_t offset, uint8_t value);

static void print_page_info(int page_id) {
    PageInfo page = sim_get_page_info(page_id);
    const char *type = page.type == PAGE_ANON ? "ANON" : "FILE";

    printf("PAGE %d type=%s resident=%d frame=%d dirty=%d swap=%d file=%d "
           "offset=%zu last=%llu\n",
           page.page_id, type, page.resident, page.frame_id, page.dirty,
           page.swap_slot, page.file_id, page.file_offset,
           (unsigned long long)page.last_access_time);
}

static void print_all_pages(void) {
    printf("STATE\n");
    for (int page_id = 0; page_id < sim_page_count(); page_id++)
        print_page_info(page_id);
}

static int process_commands(FILE *input) {
    char command[16];

    while (fscanf(input, "%15s", command) == 1) {
        if (strcmp(command, "READ") == 0) {
            int page_id;
            size_t offset;
            if (fscanf(input, "%d %zu", &page_id, &offset) != 2) {
                fprintf(stderr, "Expected: READ <page_id> <offset>\n");
                return 0;
            }

            uint8_t value = read_virtual_memory(page_id, offset);
            printf("READ %d %zu -> %u\n", page_id, offset, value);
        } else if (strcmp(command, "WRITE") == 0) {
            int page_id;
            size_t offset;
            unsigned int value;
            if (fscanf(input, "%d %zu %u", &page_id, &offset, &value) != 3 ||
                value > UINT8_MAX) {
                fprintf(stderr,
                        "Expected: WRITE <page_id> <offset> <byte_value>\n");
                return 0;
            }

            write_virtual_memory(page_id, offset, (uint8_t)value);
            printf("WRITE %d %zu <- %u\n", page_id, offset, value);
        } else if (strcmp(command, "INFO") == 0) {
            int page_id;
            if (fscanf(input, "%d", &page_id) != 1) {
                fprintf(stderr, "Expected: INFO <page_id>\n");
                return 0;
            }
            print_page_info(page_id);
        } else if (strcmp(command, "STATE") == 0) {
            print_all_pages();
        } else if (strcmp(command, "SELECT") == 0) {
            printf("SELECT -> page %d\n", select_victim_page());
        } else if (strcmp(command, "EVICT") == 0) {
            int page_id;
            if (fscanf(input, "%d", &page_id) != 1) {
                fprintf(stderr, "Expected: EVICT <page_id>\n");
                return 0;
            }
            evict_page(page_id);
            printf("EVICT page %d\n", page_id);
            print_page_info(page_id);
        } else if (strcmp(command, "LOAD") == 0) {
            int page_id;
            int frame_id;
            if (fscanf(input, "%d %d", &page_id, &frame_id) != 2) {
                fprintf(stderr, "Expected: LOAD <page_id> <frame_id>\n");
                return 0;
            }
            load_page(page_id, frame_id);
            printf("LOAD page %d into frame %d\n", page_id, frame_id);
            print_page_info(page_id);
        } else if (strcmp(command, "FAULT") == 0) {
            int page_id;
            if (fscanf(input, "%d", &page_id) != 1) {
                fprintf(stderr, "Expected: FAULT <page_id>\n");
                return 0;
            }
            int frame_id = handle_page_fault(page_id);
            printf("FAULT page %d -> frame %d\n", page_id, frame_id);
            print_page_info(page_id);
        } else {
            fprintf(stderr,
                    "Unknown command '%s'; expected READ, WRITE, INFO, STATE, "
                    "SELECT, EVICT, LOAD, or FAULT\n",
                    command);
            return 0;
        }
    }

    return 1;
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <commands.txt>\n", argv[0]);
        return 1;
    }

    FILE *input = fopen(argv[1], "r");
    if (input == NULL) {
        perror("fopen");
        return 1;
    }

    sim_init();
    int ok = process_commands(input);
    fclose(input);
    return ok ? 0 : 1;
}
