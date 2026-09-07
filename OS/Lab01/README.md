# Lab01: parmake

## Learning objectives

* Refamiliarizing yourself with C programming
* Understanding how to use the process system calls `fork()`, `execvp()`,
  and `wait()` on Linux, and how they work
* Using man pages to understand the behavior of library and system calls

## Background

Real build tools like `make -j` speed up builds by compiling independent
source files at the same time, each in its own process. In this lab you'll
build a tiny version of that using `fork()`, `execvp()`, and `wait()`.

## Starting point

You will edit exactly one file, `parmake.c`. The rest of the folder is test
material: the `tc_*.c` files are test files used by the sample tests, and
`run_tests.py` runs the tests in `testcases/` against your program.

The argument parsing at the top of `main()` is already done for you and
handles the case where too few arguments are given. **Do not modify this
part of the code.**

# Tasks

## Task 1

Include the headers you need for `fork()`, `execvp()`, and `wait()` at the
top of `parmake.c`.

You may find the man pages for these calls useful as you work through the
assignment:

* `man 2 fork`
* `man 3 exec` (for `execvp`)
* `man 2 wait`

## Task 2

For every source file given to your program, fork a child process that
compiles it by running `gcc -c <file>`. This has to happen in parallel:
every child should be running at the same time, not one after another.

You'll also need some way to remember which PID is responsible for each C file, 
so you can match them back up once they start finishing.

If `fork()` itself fails for a file, there's no child process for it. Print
the FAILED line for that file (see Task 3 for the exact format)
and move on to the next one.

## Task 3

Wait for every child process you created, in whatever order they happen to
finish. For each one, check how it exited.

For any child that did not terminate normally, print

```
FAILED: <filename.c>
```

one line per failed file. It doesn't matter what order these lines come
out in. You can print any debugging output to `stderr`, since only what's
printed to `stdout` gets compared by the autograder.

If `execvp()` fails inside a child, the child should exit with a non-zero
status.

## Task 4

If every file compiled successfully, then run

```
gcc file1.o file2.o ... fileN.o -o <output_binary>
```

from your program and return 0. If not, then return 1 without linking.

## Verify

Compile your program with:

```sh
gcc -Wall -Wextra -o parmake parmake.c
```

You can then run it directly,
```sh
./parmake -o <output_binary> <file1.c> <file2.c> ... <fileN.c>
```

For example:

```sh
./parmake -o app tc_hello.c tc_math.c tc_strings.c
```

If `gcc`'s own error messages for the intentionally broken test files get
in the way, you can mute them by redirecting `stderr`:

```sh
./parmake -o app tc_hello.c tc_bad_semicolon.c 2>/dev/null
```

Try testing your program on some of the sample test files on your own. To
clean up the `.o` files and output binaries between runs, you can use the
`clean` script provided: run `chmod +x clean` once, then `./clean` whenever
you want to reset.

Once you're confident your program works, you can run all the sample tests
with the provided python script:

```sh
python3 run_tests.py
```

You can also use it to run a single test:

```sh
python3 run_tests.py testcases/tc03_one_bad.json
```