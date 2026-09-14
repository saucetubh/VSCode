/*
 * Process-management implementation for TaskWatch.
 * This file owns worker creation, signal delivery, progress collection,
 * wait-status interpretation, task reporting, and orderly cleanup.
 */


 //this is the only file that requires changes
#define _POSIX_C_SOURCE 200809L

#include "process_manager.h"

#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define PIPE_READ_END 0
#define PIPE_WRITE_END 1
#define WORKER_PATH "./worker"

/* Find a task-table entry using the user-visible task ID. */
static Task *find_task_by_id(TaskManager *manager, int task_id)
{
    for (int i = 0; i < MAX_TASKS; ++i) {
        if (manager->tasks[i].state != TASK_UNUSED &&
            manager->tasks[i].id == task_id) {
            return &manager->tasks[i];
        }
    }

    return NULL;
}

/* Find the task associated with a PID returned by waitpid(). */
static Task *find_task_by_pid(TaskManager *manager, pid_t pid)
{
    for (int i = 0; i < MAX_TASKS; ++i) {
        if (manager->tasks[i].state != TASK_UNUSED &&
            manager->tasks[i].pid == pid) {
            return &manager->tasks[i];
        }
    }

    return NULL;
}

/* Return the next unassigned task slot, or NULL when the table is full. */
static Task *find_unused_task(TaskManager *manager)
{
    for (int i = 0; i < MAX_TASKS; ++i) {
        if (manager->tasks[i].state == TASK_UNUSED) {
            return &manager->tasks[i];
        }
    }

    return NULL;
}

/* Report whether a task still represents an unreaped child process. */
static int task_is_live(const Task *task)
{
    return task->state == TASK_RUNNING ||
           task->state == TASK_STOPPED ||
           task->state == TASK_TERMINATING;
}

/* Convert an internal task state into the label shown by the list command. */
static const char *state_name(TaskState state)
{
    switch (state) {
    case TASK_RUNNING:
        return "RUNNING";
    case TASK_STOPPED:
        return "STOPPED";
    case TASK_TERMINATING:
        return "TERMINATING";
    case TASK_COMPLETED:
        return "COMPLETED";
    case TASK_FAILED:
        return "FAILED";
    case TASK_TERMINATED:
        return "TERMINATED";
    case TASK_UNUSED:
    default:
        return "UNUSED";
    }
}

/*
 * Translate one waitpid() status into the corresponding task-table state.
 * Both normal event processing and shutdown use this shared interpretation.
 */

static void update_task_from_wait_status(Task *task, int status)
{
    if (WIFSTOPPED(status)) {
        task->state = TASK_STOPPED;
        return;
    }



    // TODO: Handle continued, exited, and signal-terminated children. 
}

/* Report a child-side setup failure and exit without returning to parent code. */
static void child_error(const char *operation)
{
    perror(operation);
    _exit(127);
}

/* Prepare an empty manager and create the pipe shared by all workers. */
int manager_init(TaskManager *manager)
{
    memset(manager, 0, sizeof(*manager));
    manager->next_id = 1;
    manager->status_pipe[PIPE_READ_END] = -1;
    manager->status_pipe[PIPE_WRITE_END] = -1;

    if (pipe(manager->status_pipe) == -1) {
        perror("pipe");
        return -1;
    }

    return 0;
}

/* Expose the status pipe's read end so taskwatch.c can monitor it. */
int manager_status_fd(const TaskManager *manager)
{
    return manager->status_pipe[PIPE_READ_END];
}

/*
 * Create a worker with fork(), redirect its standard streams, and replace the
 * child with the worker executable. The parent records the new task and PID.
 */
int manager_start_task(TaskManager *manager, int duration)
{
    Task *task = find_unused_task(manager);
    if (task == NULL) {
        fprintf(stderr, "Cannot start task: the task table is full.\n");
        return -1;
    }

    int task_id = manager->next_id;
    char task_id_text[16];
    char duration_text[16];

    snprintf(task_id_text, sizeof(task_id_text), "%d", task_id);
    snprintf(duration_text, sizeof(duration_text), "%d", duration);

    pid_t pid = fork();
    if (pid == -1) {
        perror("fork");
        return -1;
    }

    if (pid == 0) {
        /*
         * A forked child inherits both ends of the shared pipe. This child only
         * sends status, so keeping the read end would be unnecessary and could
         * interfere with detecting when pipe readers have disappeared.
         */
        if (close(manager->status_pipe[PIPE_READ_END]) == -1) {
            child_error("close");
        }

        /*
         * Make stdout (file descriptor 1) refer to the pipe's write end. The
         * worker can then write to STDOUT_FILENO without knowing about the
         * original pipe descriptor, and the parent receives those messages.
         */
        if (dup2(manager->status_pipe[PIPE_WRITE_END], STDOUT_FILENO) == -1) {
            child_error("dup2 stdout");
        }

        /* dup2() created the stdout reference, so the original FD is redundant. */
        if (manager->status_pipe[PIPE_WRITE_END] != STDOUT_FILENO &&
            close(manager->status_pipe[PIPE_WRITE_END]) == -1) {
            child_error("close");
        }

        /*
         * The child also inherits the terminal as stdin after fork(). Redirect
         * it to /dev/null so only the controller can consume typed commands.
         * Reads by the worker will immediately receive end-of-file instead.
         */
        int devnull_fd = open("/dev/null", O_RDONLY);
        if (devnull_fd == -1) {
            child_error("open /dev/null");
        }

        /* Replace stdin (file descriptor 0) with the /dev/null descriptor. */
        if (dup2(devnull_fd, STDIN_FILENO) == -1) {
            child_error("dup2 stdin");
        }

        /* stdin now refers to /dev/null, so close the extra descriptor. */
        if (devnull_fd != STDIN_FILENO && close(devnull_fd) == -1) {
            child_error("close");
        }

        /*
         * Replace the child-side TaskWatch code with worker.c's executable.
         * The PID and redirected stdin/stdout descriptors survive execvp().
         */





        //TODO: Build the worker argument array and call execvp(). 




        /* A successful execvp() never returns; reaching here means it failed. */
        child_error("execvp worker");
    }

    /* Only the parent reaches this point with pid greater than zero. */
    task->id = task_id;
    task->pid = pid;
    task->duration = duration;
    task->progress = 0;
    task->state = TASK_RUNNING;
    task->exit_code = -1;
    task->term_signal = 0;
    manager->next_id++;

    printf("Started task %d with PID %ld for %d seconds.\n",
           task->id, (long)task->pid, task->duration);
    return task->id;
}

/*
 * Validate a requested control action and deliver its POSIX signal with
 * kill(). Final stop, continue, and exit states are confirmed by waitpid().
 */
int manager_control_task(TaskManager *manager, int task_id, TaskAction action)
{
    Task *task = find_task_by_id(manager, task_id);
    if (task == NULL) {
        fprintf(stderr, "No task with ID %d.\n", task_id);
        return -1;
    }

    int signal_number;
    const char *action_name;

    /* Validate the current state and translate the command into a POSIX signal. */
    switch (action) {



    // TODO: Add cases for pause, resume, and terminate actions. 




    default:
        fprintf(stderr, "Unknown task action.\n");
        return -1;
    }

    /* kill() sends the selected signal to the PID stored for this task ID. */
    if (kill(task->pid, signal_number) == -1) {
        int saved_errno = errno;

        /* ESRCH commonly means the child exited just before this command. */
        if (saved_errno == ESRCH) {
            manager_reap_children(manager);
            fprintf(stderr, "Task %d has already finished.\n", task_id);
        } else {
            errno = saved_errno;
            perror("kill");
        }
        return -1;
    }

    if (action == TASK_TERMINATE) {



        // TODO: Record termination and ensure a stopped task can exit. 



    }

    printf("%s requested for task %d.\n", action_name, task_id);
    return 0;
}

/* Read and validate one progress record from the shared worker-status pipe. */
int manager_read_status(TaskManager *manager)
{
    TaskMessage message;
    ssize_t bytes_read;

    do {
        bytes_read = read(manager->status_pipe[PIPE_READ_END],
                          &message, sizeof(message));
    } while (bytes_read == -1 && errno == EINTR);

    if (bytes_read == -1) {
        perror("read status pipe");
        return -1;
    }

    if (bytes_read == 0) {
        return 0;
    }

    if (bytes_read != (ssize_t)sizeof(message)) {
        fprintf(stderr, "Received an incomplete worker status message.\n");
        return -1;
    }

    Task *task = find_task_by_id(manager, message.task_id);
    if (task == NULL || !task_is_live(task)) {
        return 1;
    }

    if (message.total != task->duration ||
        message.completed < task->progress ||
        message.completed > task->duration) {
        fprintf(stderr, "Ignored invalid status from task %d.\n",
                message.task_id);
        return 1;
    }

    task->progress = message.completed;
    return 1;
}

/*
 * Drain all pending child events with nonblocking waitpid() calls. Reaping in
 * normal control flow keeps the SIGCHLD handler small and signal-safe.
 */
void manager_reap_children(TaskManager *manager)
{
    /*
     * One SIGCHLD can represent several child events, so keep calling waitpid()
     * until every status currently available has been collected.
     */
    for (;;) {
        int status;

        /*
         * -1 means any child. WNOHANG prevents the controller from blocking.
         * WUNTRACED and WCONTINUED also report stop and resume events, not just
         * child termination.
         */
        pid_t pid = waitpid(_____);

        if (pid > 0) {
            /* Match the returned PID to its record and interpret the status. */
            Task *task = find_task_by_pid(manager, pid);
            if (task != NULL) {
                update_task_from_wait_status(task, status);
            }
            continue;
        }

        /* Zero means children exist but none has a new status; ECHILD means none. */
        if (pid == 0 || (pid == -1 && errno == ECHILD)) {
            return;
        }

        /* A different signal interrupted waitpid(), so safely try it again. */
        if (errno == EINTR) {
            continue;
        }

        perror("waitpid");
        return;
    }
}

/* Print all assigned task records, including completion or signal results. */
void manager_print_tasks(const TaskManager *manager)
{
    int task_count = 0;

    printf("%-4s %-7s %-12s %-10s %s\n",
           "ID", "PID", "STATE", "PROGRESS", "RESULT");

    for (int i = 0; i < MAX_TASKS; ++i) {
        const Task *task = &manager->tasks[i];
        if (task->state == TASK_UNUSED) {
            continue;
        }

        char result[64] = "-";
        if (task->state == TASK_COMPLETED) {
            snprintf(result, sizeof(result), "exit 0");
        } else if (task->state == TASK_FAILED) {
            if (task->exit_code == 127) {
                snprintf(result, sizeof(result), "exec/setup failure (127)");
            } else {
                snprintf(result, sizeof(result), "exit %d", task->exit_code);
            }
        } else if (task->state == TASK_TERMINATED) {
            const char *description = strsignal(task->term_signal);
            snprintf(result, sizeof(result), "signal %d (%s)",
                     task->term_signal,
                     description != NULL ? description : "unknown");
        }

        printf("%-4d %-7ld %-12s %d/%-8d %s\n",
               task->id,
               (long)task->pid,
               state_name(task->state),
               task->progress,
               task->duration,
               result);
        task_count++;
    }

    if (task_count == 0) {
        printf("No tasks.\n");
    }
}

/*
 * Terminate and synchronously reap every live worker before closing the pipe.
 * SIGCONT ensures a stopped worker can act on the pending SIGTERM.
 */
void manager_shutdown(TaskManager *manager)
{
    int live_tasks = 0;

    /*
     * First request termination from every live child. Signalling all workers
     * before waiting lets them begin exiting at approximately the same time.
     */
    for (int i = 0; i < MAX_TASKS; ++i) {
        Task *task = &manager->tasks[i];
        if (!task_is_live(task)) {
            continue;
        }

        live_tasks++;
        if (kill(task->pid, _____) == -1 && errno != ESRCH) {
            perror("kill SIGTERM");
        }

        /*
         * A stopped worker cannot act on pending SIGTERM. SIGCONT is harmless
         * for running workers and guarantees that a stopped one can terminate.
         */
        if (kill(task->pid, _____) == -1 && errno != ESRCH) {
            perror("kill SIGCONT");
        }
    }

    if (live_tasks > 0) {
        printf("Terminating remaining tasks...\n");
    }

    /*
     * Now wait for each still-live PID. Unlike normal event-loop reaping, this
     * intentionally blocks because shutdown must not leave children or zombies.
     */
    for (int i = 0; i < MAX_TASKS; ++i) {
        Task *task = &manager->tasks[i];
        if (!task_is_live(task)) {
            continue;
        }

        int status;
        pid_t result;
        do {
            result = waitpid(task->pid, &status, 0);
        } while (result == -1 && errno == EINTR);

        if (result == task->pid) {
            update_task_from_wait_status(task, status);
        } else if (result == -1 && errno != ECHILD) {
            perror("waitpid during shutdown");
        }
    }

    /*
     * Keep the pipe open until all workers are gone, then close both parent
     * descriptors and mark them invalid to prevent accidental reuse.
     */
    if (manager->status_pipe[PIPE_READ_END] != -1) {
        close(manager->status_pipe[PIPE_READ_END]);
        manager->status_pipe[PIPE_READ_END] = -1;
    }

    if (manager->status_pipe[PIPE_WRITE_END] != -1) {
        close(manager->status_pipe[PIPE_WRITE_END]);
        manager->status_pipe[PIPE_WRITE_END] = -1;
    }

    printf("All child processes have been reaped.\n");
}
