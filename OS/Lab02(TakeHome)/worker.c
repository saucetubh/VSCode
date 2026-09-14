//worker code for each child 
//no changes needed here just understand the implementation
#define _POSIX_C_SOURCE 200809L

#include "process_manager.h"

#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/* Parse a strictly positive decimal integer supplied on the command line. */
static int parse_positive_integer(const char *text, int *value)
{
    if (text == NULL || *text == '\0') {
        return -1;
    }

    errno = 0;
    char *end = NULL;
    long parsed = strtol(text, &end, 10);

    if (errno == ERANGE || end == text || *end != '\0' ||
        parsed < 1 || parsed > INT_MAX) {
        return -1;
    }

    *value = (int)parsed;
    return 0;
}

/* Write one complete, fixed-size progress record to redirected stdout. */
static int send_status(const TaskMessage *message)
{
    ssize_t written;

    do {
        written = write(STDOUT_FILENO, message, sizeof(*message));
    } while (written == -1 && errno == EINTR);

    if (written != (ssize_t)sizeof(*message)) {
        return -1;
    }

    return 0;
}

/* Complete a full second of sleep even if an unrelated signal interrupts it. */
static void sleep_one_second(void)
{
    unsigned int remaining = 1;
    while (remaining != 0) {
        remaining = sleep(remaining);
    }
}

/* Validate worker arguments, perform timed work, and report each completed unit. */
int main(int argc, char *argv[])
{
    if (argc != 3) {
        fprintf(stderr, "Usage: worker <task-id> <duration-seconds>\n");
        return EXIT_FAILURE;
    }

    int task_id;
    int duration;
    if (parse_positive_integer(argv[1], &task_id) == -1 ||
        parse_positive_integer(argv[2], &duration) == -1) {
        fprintf(stderr, "worker: task ID and duration must be positive integers\n");
        return EXIT_FAILURE;
    }

    for (int completed = 1; completed <= duration; ++completed) {
        sleep_one_second();

        TaskMessage message = {
            .task_id = task_id,
            .completed = completed,
            .total = duration
        };

        if (send_status(&message) == -1) {
            perror("worker write");
            return EXIT_FAILURE;
        }
    }

    return EXIT_SUCCESS;
}
