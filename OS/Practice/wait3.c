#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>

int main() {
    pid_t child_pid = fork();

    if (child_pid == 0) {
        // Child loops forever doing background work
        while(1) {
            sleep(1);
        }
    } else {
        int status;
        int seconds_waited = 0;

        while (1) {
            // Check child status instantly
            pid_t result = waitpid(child_pid, &status, WUNTRACED | WCONTINUED | WNOHANG);

            if (result == 0) {
                // 1. No state changes yet.
                printf("Parent checking... Child is still running normally.\n");
                sleep(1);
                seconds_waited++;

                // If 3 seconds pass and the child is still running, kill it!
                if (seconds_waited == 3) {
                    printf("[Parent] Child took too long. Sending SIGKILL now!\n");
                    kill(child_pid, SIGKILL);
                    // The child dies right here, but 'result' is still 0.
                    // The loop will now finish this pass and catch the death on the next pass.
                }
            } 
            else if (result > 0) {
                // 2. Woke up because of a state change!
                if (WIFEXITED(status)) {
                    printf("Child finished normally.\n");
                    break;
                }
                if (WIFSIGNALED(status)) {
                    // This block will execute on the loop iteration RIGHT AFTER the kill() command was sent!
                    printf("Parent caught the death! Child %d was killed by signal %d.\n", result, WTERMSIG(status));
                    break;
                }
            } 
            else {
                perror("waitpid failed");
                break;
            }
        }
    }
    return 0;
}
