

//this is the main wiring of taskwatch 
//understand how the code is wired together and the entry point into process_manager.c

#define _POSIX_C_SOURCE 200809L

#include "process_manager.h"

#include <errno.h>
#include <limits.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/select.h>
#include <unistd.h>

#define INPUT_BUFFER_SIZE 256

static volatile sig_atomic_t child_event = 0;
static volatile sig_atomic_t shutdown_requested = 0;

/* Notify the event loop that one or more child states are ready to collect. */
static void handle_sigchld(int signal_number)
{
    (void)signal_number;
    child_event = 1;
}

/* Request orderly shutdown when the controller receives Ctrl-C. */ 
static void handle_sigint(int signal_number)
{
    (void)signal_number;
    shutdown_requested = 1;
}

/* Install the minimal SIGCHLD and SIGINT handlers used by the event loop. */
static int install_signal_handlers(void)
{
    struct sigaction action;

    memset(&action, 0, sizeof(action));
    sigemptyset(&action.sa_mask);
    action.sa_handler = handle_sigchld;
    if (sigaction(SIGCHLD, &action, NULL) == -1) {
        perror("sigaction SIGCHLD");
        return -1;
    }

    memset(&action, 0, sizeof(action));
    sigemptyset(&action.sa_mask);
    action.sa_handler = handle_sigint;
    if (sigaction(SIGINT, &action, NULL) == -1) {
        perror("sigaction SIGINT");
        return -1;
    }

    return 0;
}

/* Display the small command language supported by the barebones supervisor. */
static void print_help(void)
{
    printf("Commands:\n");
    printf("  start <seconds>  Start a new worker (%d-%d seconds)\n",
           MIN_TASK_DURATION, MAX_TASK_DURATION);
    printf("  list             Show all tasks\n");
    printf("  pause <id>       Pause a running task\n");
    printf("  resume <id>      Resume a stopped task\n");
    printf("  terminate <id>   Terminate an active task\n");
    printf("  help             Show this help\n");
    printf("  quit             Terminate workers and exit\n");
}

/* Parse and range-check a decimal integer without atoi()'s ambiguity. */
static int parse_integer(const char *text, int minimum, int maximum,
                         int *value)
{
    if (text == NULL || *text == '\0') {
        return -1;
    }

    errno = 0;
    char *end = NULL;
    long parsed = strtol(text, &end, 10);

    if (errno == ERANGE || end == text || *end != '\0' ||
        parsed < minimum || parsed > maximum || parsed > INT_MAX) {
        return -1;
    }

    *value = (int)parsed;
    return 0;
}

/* Check that a command intended to take no arguments received none. */
static int command_has_no_extra_argument(char *argument, char *extra)
{
    return argument == NULL && extra == NULL;
}

/*
 * Parse one input line and dispatch it to the appropriate manager operation.
 * Return zero only when the caller should leave the event loop.
 */
static int handle_command(TaskManager *manager, char *line)
{
    const char *delimiters = " \t\r\n";
    char *command = strtok(line, delimiters);
    char *argument = strtok(NULL, delimiters);
    char *extra = strtok(NULL, delimiters);

    if (command == NULL) {
        return 1;
    }

    if (strcmp(command, "help") == 0) {
        if (!command_has_no_extra_argument(argument, extra)) {
            fprintf(stderr, "Usage: help\n");
        } else {
            print_help();
        }
        return 1;
    }

    if (strcmp(command, "list") == 0) {
        if (!command_has_no_extra_argument(argument, extra)) {
            fprintf(stderr, "Usage: list\n");
        } else {
            manager_reap_children(manager);
            manager_print_tasks(manager);
        }
        return 1;
    }

    if (strcmp(command, "quit") == 0) {
        if (!command_has_no_extra_argument(argument, extra)) {
            fprintf(stderr, "Usage: quit\n");
            return 1;
        }
        return 0;
    }

    if (strcmp(command, "start") == 0) {
        int duration;
        if (extra != NULL ||
            parse_integer(argument, MIN_TASK_DURATION,
                          MAX_TASK_DURATION, &duration) == -1) {
            fprintf(stderr, "Usage: start <seconds>, where seconds is %d-%d.\n",
                    MIN_TASK_DURATION, MAX_TASK_DURATION);
        } else {
            manager_start_task(manager, duration);
        }
        return 1;
    }

    TaskAction action;
    const char *usage;

    if (strcmp(command, "pause") == 0) {
        action = TASK_PAUSE;
        usage = "pause <id>";
    } else if (strcmp(command, "resume") == 0) {
        action = TASK_RESUME;
        usage = "resume <id>";
    } else if (strcmp(command, "terminate") == 0) {
        action = TASK_TERMINATE;
        usage = "terminate <id>";
    } else {
        fprintf(stderr, "Unknown command: %s\n", command);
        return 1;
    }

    int task_id;
    if (extra != NULL || parse_integer(argument, 1, INT_MAX, &task_id) == -1) {
        fprintf(stderr, "Usage: %s\n", usage);
        return 1;
    }

    manager_control_task(manager, task_id, action);
    return 1;
}

/*
 * Initialize TaskWatch and run the select()-based controller loop. Stdin and
 * worker messages share the loop so the parent remains responsive to both.
 */
int main(void)
{
    TaskManager manager;
    if (manager_init(&manager) == -1) {
        return EXIT_FAILURE;
    }

    if (install_signal_handlers() == -1) {
        manager_shutdown(&manager);
        return EXIT_FAILURE;
    }

    printf("TaskWatch process supervisor\n");
    printf("Type \"help\" for available commands.\n\n");

    int keep_running = 1;
    int prompt_needed = 1;  
    int exit_status = EXIT_SUCCESS;

    while (keep_running && !shutdown_requested) {
        if (child_event) {
            child_event = 0;
            manager_reap_children(&manager);
        }

        if (shutdown_requested) {
            break;
        }

        if (prompt_needed) {
            printf("taskwatch> ");
            fflush(stdout);
            prompt_needed = 0;
        }

        int status_fd = manager_status_fd(&manager);
        fd_set read_fds;
        FD_ZERO(&read_fds);
        FD_SET(STDIN_FILENO, &read_fds);
        FD_SET(status_fd, &read_fds);

        struct timeval timeout = {
            .tv_sec = 0,
            .tv_usec = 500000
        };

        int highest_fd = status_fd > STDIN_FILENO ? status_fd : STDIN_FILENO;
        int ready = select(highest_fd + 1, &read_fds, NULL, NULL, &timeout);

        if (ready == -1) {
            if (errno == EINTR) {
                continue;
            }
            perror("select");
            exit_status = EXIT_FAILURE;
            break;
        }

        if (ready == 0) {
            manager_reap_children(&manager);
            continue;
        }

        if (FD_ISSET(status_fd, &read_fds)) {
            if (manager_read_status(&manager) == -1) {
                exit_status = EXIT_FAILURE;
                break;
            }
        }

        if (FD_ISSET(STDIN_FILENO, &read_fds)) {
            char input[INPUT_BUFFER_SIZE];
            if (fgets(input, sizeof(input), stdin) == NULL) {
                keep_running = 0;
            } else {
                keep_running = handle_command(&manager, input);
            }
            prompt_needed = 1;
        }
    }

    if (shutdown_requested) {
        printf("\nInterrupt received. Shutting down.\n");
    }

    manager_shutdown(&manager);
    return exit_status;
}
