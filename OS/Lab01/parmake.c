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

// TODO: include the headers you need for fork, exec, and wait

/*
 * GIVEN: c_to_o("foo.c") returns a new string "foo.o" allocated on the heap.
 *
 * You will need this for the final step in which you create the executable by linking all the created .o files.
 *
 */
char *c_to_o(const char *cfile) {
    char *ofile = strdup(cfile);
    ofile[strlen(ofile) - 1] = 'o';
    return ofile;
}

int main(int argc, char *argv[]) {
    if (argc <= 3 || strcmp(argv[1], "-o") != 0) {
        fprintf(stderr, "usage: %s -o <output_binary> <file1.c> [file2.c ...]\n", argv[0]);
        return 0;
    }

    const char *output_binary = argv[2];
    int nfiles = argc - 3;   /* how many source files were given as input */
    char **files = &argv[3]; /* files[0] .. files[nfiles - 1]       */

    // TODO: find a way to store the pid and filename for each child you
    // fork below, so you can match them back up in the next step.
    // Hint: arrays work fine here.

    // TODO: fork a child process to compile each file, running
    // `gcc -c <file>`. This has to be parallel; every child should be
    // running at once, not one at a time.

    // TODO: wait for every child you forked and check how it exited.
    // Print "FAILED: <filename.c>" for any file whose compile failed.
    // Check the man pages above for how to do this.

    // TODO: if every file compiled successfully, link the .o files into
    // <output_binary>, and return 0. Otherwise, return 1 without linking.

    return 0;
}