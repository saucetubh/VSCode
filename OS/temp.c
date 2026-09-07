#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <signal.h>
#include <time.h>
#include <sys/wait.h>

#define MAX_TASKS 100

typedef enum { RUNNING, PAUSED, TERMINATED, DONE } Status;
typedef enum { SLEEP, EXEC } Kind;

/* External programs run for "start e<N>". Indexed by N-1. */
static char *const exec_options[][4] = {
    { "/bin/echo",  "hello from exec", NULL },      /* e1 */
    { "/usr/bin/wc", "-l", "/etc/passwd", NULL },   /* e2 */
};
#define EXEC_COUNT (sizeof(exec_options) / sizeof(exec_options[0]))

typedef struct {
    int task_id;     /* unique id handed out to each new task */
    pid_t pid;       /* process id of the child running this task */
    int value;       /* seconds for a sleep task, program index for an exec task */
    Kind kind;       /* SLEEP or EXEC */
    double start;    /* wall-clock time when the task was started */
    double end;      /* wall-clock time when it finished (0.0 until then) */
    Status status;   /* RUNNING, PAUSED, TERMINATED, or DONE */
} Task;

Task tasks[MAX_TASKS];
int task_count = 0;
int next_id = 1;

volatile sig_atomic_t resumed = 0;

void handle_sigcont(int sig) {
    (void)sig;
    resumed = 1;
}

double get_time(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

/*
 * Count only actual running time; stopped (paused) intervals are ignored.
 */
void custom_sleep(double seconds) {
    double last = get_time();
    double elapsed = 0.0;

    while (elapsed < seconds) {
        double current = get_time();
        if (resumed) {              /* just resumed from pause */
            last = current;
            resumed = 0;
            continue;
        }
        elapsed += current - last;
        last = current;
    }
}

/*
 * TODO: run the right thing for a task.
 *
 * For a sleep task, the child just waits, then ends. That part is
 * already written below -- leave it alone.
 *
 * For an exec task, the child must turn itself into the external program
 * listed in exec_options. When that works, the child never comes back
 * here.
 *
 * Pointers:
 *  - kind tells you which of the two to do; value picks the program.
 *  - If turning into the program fails, fall through to _exit(127).
 */
void worker(Kind kind, int value) {
    if (kind == SLEEP) {
        custom_sleep(value);
        _exit(0);                   /* child: skip inherited FILE* flush */
    }
    
    execvp(exec_options[value-1][0], exec_options[value-1]);

    _exit(127);                     /* only reached if exec fails */
}

int find(int id) {
    for (int i = 0; i < task_count; i++)
        if (tasks[i].task_id == id)
            return i;
    return -1;
}

/*
 * TODO: start a new task.
 *
 * Make a fresh child process, have it run worker(kind, value), and
 * remember the new task in the `tasks` table so the rest of the program
 * can find it later. Return its task id.
 *
 * Pointers:
 *  - The parent and the child both keep running after this, side by side.
 *  - Fill in every field of the new task entry (id, pid, value, kind,
 *    start, end, status), then increase by one the values of 
 *    task_count and next_id.
 */
int cmd_start(Kind kind, int value) {
    pid_t pid = fork();
    if(pid==0) {
        worker(kind, value);
    }
    else if(pid) {
        int curr_id = next_id;
        Task T = {curr_id, pid, value, kind, get_time(), 0.0, RUNNING};
        tasks[task_count++] = T;
        next_id++;
        return curr_id;
    }
    return 0;
}

/*
 * TODO: check whether a task's child has finished.
 *
 * If it has, mark the task done so the program reports it and doesn't
 * leave a zombie. Return 1 if it was reaped, 0 otherwise.
 *
 * Pointers:
 *  - Update the condition inside if() to check for the status of the child process
 *    Hint: Use the waitpid() system call
 *  - When it has exited, update the task's status and end time. Use the
 *    get_time() helper for the timestamp.
 */
int check_status(int id) {
    int i = find(id);
    if (i == -1) return 0;

    int status; //can be used if we want to know whether child exited normally, was terminated, or paused, etc.
    
    pid_t child_pid = waitpid(tasks[i].pid, &status, WNOHANG); //returns 0 if child still running, parent can continue what its doing (non blocking), returns pid of the child if reaped, returns -1 if nothing to reap
    if (child_pid) {
        tasks[i].end = get_time();
        tasks[i].status = DONE;
        printf("[%.3f] task %d exited\n", get_time(), tasks[i].task_id);
        return 1;
    }
    return 0;
}

/*
 * Reap every worker that just finished.
 */
void reap_all(void) {
    for (int i = 0; i < task_count; i++)
        check_status(tasks[i].task_id);
}

/*
 * TODO: terminate a task.
 *
 * Stop a task for good and clean up its child process so it doesn't
 * linger as a zombie. Update the task's status and end time.
 *
 * Pointers:
 *  - Give up silently if the task doesn't exist or already finished.
 *  - A signal does the killing; after that the child must be reaped.
 */
void cmd_terminate(int id) {
    int i = find(id);
    if (i==-1) return;
    if (check_status(tasks[i].task_id)) return;
    kill(tasks[i].pid, SIGKILL);
    int status;
    pid_t child_pid = waitpid(tasks[i].pid, &status, 0);
    if(child_pid) {
        if(WIFSIGNALED(status)) {
            tasks[i].status = TERMINATED;
            tasks[i].end = get_time();
        }
    }
}

/*
 * TODO: pause a task.
 *
 * Make a task stop where it is, without destroying it, so it can be
 * resumed later. Update the task's status.
 *
 * Pointers:
 *  - Give up silently if the task doesn't exist or already finished.
 *  - A signal can suspend a running process in place.
 */
void cmd_pause(int id) {
    int i = find(id);
    if(i==-1) return;
    if (check_status(tasks[i].task_id)) return;
    kill(tasks[i].pid, SIGSTOP);
    tasks[i].status = PAUSED;
}

/*
 * TODO: resume a task.
 *
 * Wake a paused task back up so it keeps running. Update the task's
 * status.
 *
 * Pointers:
 *  - Give up silently if the task doesn't exist or already finished.
 *  - There is a signal for restarting a suspended process.
 */
void cmd_resume(int id) {
    int i = find(id);
    if(i==-1) return;
    if (check_status(tasks[i].task_id)) return;
    kill(tasks[i].pid, SIGCONT);
    tasks[i].status = RUNNING;
}

int main(int argc, char **argv) {
    /* Parse --test-mode (duplicates stdout to output.txt) and the cmd file. */
    int test_mode = 0;
    const char *path = NULL;
    for (int i = 1; i < argc; i++) {
        if (!strcmp(argv[i], "--test-mode"))
            test_mode = 1;
        else
            path = argv[i];
    }

    if (!path) {
        fprintf(stderr, "usage: %s [--test-mode] commands.txt\n", argv[0]);
        return 1;
    }

    if (test_mode) {
        int fd = open("output.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd != -1)
            dup2(fd, STDOUT_FILENO);
    }

    struct sigaction sa = {0};
    sa.sa_handler = handle_sigcont;
    sigaction(SIGCONT, &sa, NULL);

    FILE *f = fopen(path, "r");
    char cmd[32];
    int val;

    while (fscanf(f, "%31s", cmd) == 1) {
        if (!strcmp(cmd, "start")) {
            char spec[16];
            fscanf(f, "%15s", spec);
            char kind = spec[0];            /* 's' = sleep, 'e' = exec */
            int value = atoi(spec + 1);

            Kind k = (kind == 'e') ? EXEC : SLEEP;
            int id = cmd_start(k, value);
            if (k == SLEEP)
                printf("[%.3f] started task %d (pid %d) for %ds\n",
                       get_time(), id, tasks[id - 1].pid, value);
            else
                printf("[%.3f] started task %d (pid %d) running %s\n",
                       get_time(), id, tasks[id - 1].pid,
                       exec_options[value - 1][0]);
        } else if (!strcmp(cmd, "terminate")) {
            fscanf(f, "%d", &val);
            cmd_terminate(val);
            printf("[%.3f] terminated task %d\n", get_time(), val);
        } else if (!strcmp(cmd, "pause")) {
            fscanf(f, "%d", &val);
            cmd_pause(val);
            printf("[%.3f] paused task %d\n", get_time(), val);
        } else if (!strcmp(cmd, "resume")) {
            fscanf(f, "%d", &val);
            cmd_resume(val);
            printf("[%.3f] resumed task %d\n", get_time(), val);
        } else if (!strcmp(cmd, "wait")) {
            fscanf(f, "%d", &val);
            printf("[%.3f] begin wait %ds\n", get_time(), val);
            sleep(val);
            printf("[%.3f] end wait %ds\n", get_time(), val);
        }

        reap_all();                 /* report workers that just finished */
    }

    fclose(f);

    /*
     * Paused workers can never finish on their own, so kill them.
     * Running workers are waited on so their exit is reported.
     */
    for (int i = 0; i < task_count; i++)
        if (tasks[i].status == PAUSED) {
            kill(tasks[i].pid, SIGKILL);
            waitpid(tasks[i].pid, NULL, 0);
            tasks[i].status = TERMINATED;
        }
    for (int i = 0; i < task_count; i++)
        if (tasks[i].status == RUNNING && !check_status(tasks[i].task_id)) {
            int status;
            waitpid(tasks[i].pid, &status, 0);      /* block until it exits */
            tasks[i].status = DONE;
            tasks[i].end = get_time();
            printf("[%.3f] task %d exited\n", get_time(), tasks[i].task_id);
        }

    return 0;
}
