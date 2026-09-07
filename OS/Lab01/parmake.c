/*
 * parmake: compile multiple C files, then link them into one binary.
 *
 *
 * Usage:
 *     ./parmake -o <output_binary> <file1.c> <file2.c> ... <fileN.c>
 *
 * Build:
 *     gcc -Wall -Wextra -o parmake parmake.c
 *
 * Fill in main() below. Argument parsing and one string helper are already
 * done for you. The full spec is in README.md.
 *
 * Useful man pages:
 *     man 2 fork        man 3 exec (execvp)        man 2 wait
 *
 */
#include <stdio.h>  /* printf, fprintf */
#include <stdlib.h> /* malloc */
#include <string.h> /* strcmp, strlen, strdup */
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>

char *c_to_o(const char *cfile) {
    char *ofile = strdup(cfile);
    ofile[strlen(ofile) - 1] = 'o';
    return ofile;
}

int main(int argc, char *argv[]) { //char *argv[] means an array of pointers is passed as the argument, each pointer points to a string
    if (argc <= 3 || strcmp(argv[1], "-o") != 0) {
        fprintf(stderr, "usage: %s -o <output_binary> <file1.c> [file2.c ...]\n", argv[0]);
        return 0;
    }

    const char *output_binary = argv[2];
    int nfiles = argc - 3;   /* how many source files were given as input */
    char **files = &argv[3]; /* files[0] .. files[nfiles - 1]       */

    pid_t pids[nfiles];
    for(int i=0;i<nfiles;i++) {
        pid_t pid = fork();
        if(pid<0) {
            fprintf(stderr, "FAILED: %s\n",files[i]);
            pids[i]=-1;
            continue;
        }
        else if(pid) {
            pids[i]=pid;
            continue;
        }
        char *myarg[4] = {"gcc", "-c", files[i], NULL};
        execvp(myarg[0], myarg); //execvp takes as argument a single string pointer which is the filename that has to be executed (in this case gcc), and the second argument is the entire array of strings, myarg is char**, it points to the first element
        exit(1); //only falls to this line if execvp fails, so we exit with 0 to indicate failure
        //exit() is a graceful shutdown, _Exit() is a force shutdown
        //_Exit is like pressing the handbrake to stop instantly, can be used here to prevent a bad child from corrupting parent, since _Exit immediately shuts down
        //exit() does proper clean up and flushes the buffer etc.
    }
    
    int failures=0;
    for(int i=0;i<nfiles;i++) {
        int status;
        pid_t pid = pids[i];
        if(waitpid(pid, &status, 0)) {//need to pass the address of status so that the wait call can change the value of my status variable, if i pass only the status, the change wait will make is to its own copy of the status
            if(WIFEXITED(status) && WEXITSTATUS(status) != 0) {
                printf("FAILED: %s\n",files[i]);
                failures++;
                continue;
            }
        }
        else break;
    }

    if(failures>0) return 1;

    char *finalarg[nfiles+4]; //if N files, we need N+4 arguments (null termination)
    finalarg[0] = "gcc";
    for(int i=0;i<nfiles;i++) {
        finalarg[i+1] = c_to_o(files[i]);
    }
    finalarg[nfiles+1] = "-o";
    finalarg[nfiles+2] = (char *) output_binary;
    finalarg[nfiles+3] = NULL;
    
    pid_t pid = fork();
    if(pid<0) return 1;
    else if(pid == 0) {
        execvp(finalarg[0], finalarg);
        exit(1); //link failed, child exited with non zero status
    }
    wait(NULL); //parents waits
    return 0; //can add a similar condition as earlier where we save status and use macro to check it and return 0 only if the child did not terminate with an exit status since that would mean execvp failed
    //but for simplicity we don't
}