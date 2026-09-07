#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {
        // CHILD PROCESS
        while (1) {
            printf("Child is working hard...\n");
            sleep(1);
        }
    } else {
        // PARENT PROCESS
        int status;
        
        // Let the child run for 3 seconds
        sleep(3);

        // STEP 1: Parent decides to pause the child
        printf("\n[Parent]: Pausing the child process...\n");
        kill(pid, SIGSTOP);

        // Parent calls waitpid with BOTH flags to track stops and starts
        waitpid(pid, &status, WUNTRACED | WCONTINUED);
        
        if (WIFSTOPPED(status)) {
            printf("[Parent]: Confirmed via waitpid: Child is PAUSED by signal %d.\n", WSTOPSIG(status));
        }

        // Parent takes its time doing something else while child is frozen
        printf("[Parent]: Doing other calculations for 3 seconds...\n");
        sleep(3);

        // STEP 2: Parent decides to resume the child
        printf("\n[Parent]: Waking the child back up...\n");
        kill(pid, SIGCONT);

        // Parent blocks again, waiting for the child's status to change
        waitpid(pid, &status, WUNTRACED | WCONTINUED);

        if (WIFCONTINUED(status)) {
            printf("[Parent]: Confirmed via waitpid: Child has RESUMED running!\n");
        }

        // STEP 3: Let it run a bit, then kill it permanently
        sleep(2);
        printf("\n[Parent]: Killing the child permanently.\n");
        kill(pid, SIGKILL);
        
        waitpid(pid, &status, 0);
        if (WIFSIGNALED(status)) {
            printf("[Parent]: Child is officially dead.\n");
        }
    }
    return 0;
}
