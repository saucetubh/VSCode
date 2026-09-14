

 //header functions and definitions no changes required here just understand the structures / functions used
#ifndef PROCESS_MANAGER_H
#define PROCESS_MANAGER_H

#include <sys/types.h>

#define MAX_TASKS 16
#define MIN_TASK_DURATION 1
#define MAX_TASK_DURATION 300

typedef enum {
    TASK_UNUSED,
    TASK_RUNNING,
    TASK_STOPPED,
    TASK_TERMINATING,
    TASK_COMPLETED,
    TASK_FAILED,
    TASK_TERMINATED
} TaskState;

typedef enum {
    TASK_PAUSE,
    TASK_RESUME,
    TASK_TERMINATE
} TaskAction;

/* Workers send one fixed-size message after each second of work. */
typedef struct {
    int task_id;
    int completed;
    int total;
} TaskMessage;

typedef struct {
    int id;
    pid_t pid;
    int duration;
    int progress;
    TaskState state;
    int exit_code;
    int term_signal;
} Task;

typedef struct {
    Task tasks[MAX_TASKS];
    int next_id;
    int status_pipe[2];
} TaskManager;

/* Initialize the task table and create the shared worker-status pipe. */
int manager_init(TaskManager *manager);

/* Return the pipe descriptor monitored by the controller's event loop. */
int manager_status_fd(const TaskManager *manager);

/* Fork and execute a worker, then record it in the task table. */
int manager_start_task(TaskManager *manager, int duration);

/* Send the signal associated with a pause, resume, or terminate action. */
int manager_control_task(TaskManager *manager, int task_id, TaskAction action);

/* Read one worker progress message and apply it to the matching task. */
int manager_read_status(TaskManager *manager);

/* Collect all currently available child state changes without blocking. */
void manager_reap_children(TaskManager *manager);

/* Display the current task table in a human-readable format. */
void manager_print_tasks(const TaskManager *manager);

/* Terminate, reap, and release resources for all remaining workers. */
void manager_shutdown(TaskManager *manager);

#endif
