/*
int status;
pid_t result = waitpid(child_pid, &status, WUNTRACED | WCONTINUED | WNOHANG);

if (result == 0) {
1. ABSOLUTELY NOTHING CHANGED.
The child is either still running normally, or still sitting silently paused. 
The parent can safely do other tasks here without freezing.
} 
else if (result > 0) {
 2. SOMETHING CHANGED! Now evaluate the macros:
    if (WIFEXITED(status))     { Child finished normally }
    if (WIFSIGNALED(status))   { Child was killed }
    if (WIFSTOPPED(status))    { Child was just paused! }
    if (WIFCONTINUED(status))  { Child was just resumed! }
} 
else {
    3. result == -1 (An error occurred, e.g., no such PID)
    perror("waitpid failed");
}
*/