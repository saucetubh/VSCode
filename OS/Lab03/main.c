#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <signal.h>

#define TIME_LIMIT_SECONDS 5
#define PAUSE_AFTER_SECONDS 3

static char programs_dir[256] = "./bin";

/*
 * HELPER: Start a worker process
 *
 * Returns the PID of the newly created child.
 */
static pid_t spawn_process(int id) {
    char path[256];

    /* Builds the path to the worker executable 
    Example: path = ./bin/prog1 
    This path is already being built.
    */
    snprintf(path, sizeof(path), "%s/prog%d", programs_dir, id);

    /* TODO: Create a child process. */
    pid_t pid = fork();
    /* TODO: In the child, replace the process image with the worker. */
    if(pid==0) {
        char *myargs[2];
        myargs[0] = path;
        myargs[1] = NULL;
        execvp(myargs[0], myargs); 
        _exit(127);
    }
    /* TODO: Return the child's PID to the caller. */
    return pid;
}

/*
 * HELPER: Wait for a process with a timeout
 *
 * Returns:
 *     1 if the process completed successfully
 *     0 if it failed or timed out
 *
 * start_time is the time at which the process was started.
 */
static int wait_with_timeout(pid_t pid, int id, time_t start_time) {
    int status;
    while (1) {
        /* TODO: Check whether the process has finished without blocking. */
        /* TODO: If it has finished, check whether it exited successfully.
         *
         *   On success:  return 1
         *   On failure:  printf("ERROR: P%d exited with code <code>\n", id);
         *                return 0
         */
        pid_t child = waitpid(pid, &status, WNOHANG);
        if(child == pid) {
        if(WIFEXITED(status)) {
            if(WEXITSTATUS(status) != 0) {
                printf("ERROR: P%d exited with code %d\n", id, WEXITSTATUS(status));
                waitpid(pid,NULL,0);
                return 0;
            }
            else {
                waitpid(pid,NULL,0);
                return 1;
            }
        }
    }
        /* TODO: Check whether the process has exceeded the time limit.
         *   Terminate the process and reap the zombie.
         *
         *   printf("TIMEOUT: P%d exceeded <seconds>s\n", id);
         *   return 0
         */
        else {
            if(time(NULL) - start_time > TIME_LIMIT_SECONDS) { 
            kill(pid, SIGKILL);
            waitpid(pid, NULL, 0);
            printf("TIMEOUT: P%d exceeded %ds\n", id, TIME_LIMIT_SECONDS);
            return 0;
        }
        }
    }
}

int main(int argc, char **argv) {
    /* Keep output line-buffered so messages appear in the right order
     * when the program's stdout is captured by the autograder.
     * Do not remove this line.
     */
    setvbuf(stdout, NULL, _IOLBF, 0);

    /* The worker-program directory can be passed as argv[1].
     * Defaults to "./bin" if omitted.
     * Do not modify this block.
     */
    if (argc > 1) {
        strncpy(programs_dir, argv[1], sizeof(programs_dir) - 1);
        programs_dir[sizeof(programs_dir) - 1] = '\0';
    }

    /* ------------------------------------------------------------------
     * Stage A -- Serial
     *
     * Run P1, then P2, then P3, each one after the previous finishes.
     * Do not start a process if the one before it failed or timed out.
     * 
     * HINT: time(NULL) gives the current time.
     * ------------------------------------------------------------------ */

    /* TODO */
    pid_t p1 = spawn_process(1);
    if(!wait_with_timeout(p1, 1, time(NULL))) {
        return 0;
    }
    pid_t p2 = spawn_process(2);
    if(!wait_with_timeout(p2, 2, time(NULL))) {
        return 0;
    }
    pid_t p3 = spawn_process(3);
    if(!wait_with_timeout(p3, 3, time(NULL))) {
        return 0;
    }    
    /* ------------------------------------------------------------------
     * Stage B -- Parallel
     *
     * Start P4, P5, and P6 at the same time, then wait for all three.
     *
     * Each process has its own 5-second timeout, measured from the moment
     * it was spawned.
     *
     * Do not continue if P4, P5, or P6 failed or timed out.
     * ------------------------------------------------------------------ */

    /* TODO */
    pid_t p4 = spawn_process(4);
    pid_t p5 = spawn_process(5);
    pid_t p6 = spawn_process(6);
    if(!wait_with_timeout(p4, 4, time(NULL)) || !wait_with_timeout(p5, 5, time(NULL)) || !wait_with_timeout(p6, 6, time(NULL))) {
        return 0;
    }
    /* ------------------------------------------------------------------
     * Stage C -- Pause / Resume
     *
     * Start P7. After PAUSE_AFTER_SECONDS, pause it.
     * Run P8 to completion. Then resume P7 and wait for it to finish.
     *
     * If P8 fails or times out, do not resume P7. Terminate it instead.
     * ------------------------------------------------------------------ */

    /* TODO */
    pid_t p7 = spawn_process(7);
    sleep(PAUSE_AFTER_SECONDS);
    kill(p7, SIGSTOP);
    waitpid(p7,NULL,WUNTRACED);
    pid_t p8 = spawn_process(8);
    if(!wait_with_timeout(p8, 8, time(NULL))) {
        kill(p7, SIGKILL);
        waitpid(p7,NULL,0);
        return 0;
    }
    else {
        kill(p7, SIGCONT);
        waitpid(p7, NULL, 0);
    }
    return 0;
}
