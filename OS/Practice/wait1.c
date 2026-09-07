#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {
        // Child Process: Loop indefinitely simulating background work
        while(1) {
            printf("Child working...\n");
            sleep(2);
        }
    } else {
        // Parent Process
        int status;
        
        printf("Parent monitoring child (PID: %d)...\n", pid);

        while (1) {
            // CRITICAL: WUNTRACED lets us catch paused states.
            // WCONTINUED lets us catch when a paused process is resumed.
            pid_t caught_pid = waitpid(pid, &status, WUNTRACED | WCONTINUED);

            if (caught_pid == -1) {
                perror("waitpid error");
                exit(1);
            }

            // Scenario A: Child exited normally (e.g., exit(0))
            if (WIFEXITED(status)) {
                printf("Child exited normally with status %d\n", WEXITSTATUS(status));
                break; 
            }
            
            // Scenario B: Child was forcefully killed (e.g., SIGKILL, SIGTERM, Ctrl+C)
            else if (WIFSIGNALED(status)) {
                printf("Child terminated by signal %d (%s)\n", 
                        WTERMSIG(status), 
                        WTERMSIG(status) == 9 ? "SIGKILL" : "Other Signal");
                break; 
            }
            
            // Scenario C: Child was suspended/paused (e.g., SIGSTOP, Ctrl+Z)
            else if (WIFSTOPPED(status)) {
                printf("Child was paused by signal %d\n", WSTOPSIG(status));
                printf("Parent can do other things while child sleeps...\n");
            }
            
            // Scenario D: Child was resumed (e.g., SIGCONT or 'fg' command)
            else if (WIFCONTINUED(status)) {
                printf("Child has been resumed! Resuming monitoring...\n");
            }
        }
    }
    return 0;
}
