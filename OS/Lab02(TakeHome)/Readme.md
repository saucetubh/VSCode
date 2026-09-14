# TaskWatch

TaskWatch is a small command-line process supervisor. It starts worker processes, tracks their progress, and lets the user pause, resume, or terminate them.

The program demonstrates how a parent process manages child processes using operating-system interfaces such as:

- `fork()` to create a child process;
- `execvp()` to run the worker program inside the child;
- `pipe()` and `dup2()` to send worker progress to the parent;
- `kill()` to send control signals;
- `sigaction()` to respond to process events; and
- `waitpid()` to collect child state changes and prevent zombie processes.

## Building TaskWatch


```sh
make
```

This creates two executables:

- `taskwatch`, the interactive parent/controller program;
- `worker`, the child program started by TaskWatch.

To remove the compiled files, run:

```sh
make clean
```

## Running TaskWatch

Start the program with:

```sh
./taskwatch
```

TaskWatch displays the `taskwatch>` prompt and waits for a command. A task duration must be between 1 and 300 seconds. Up to 16 tasks can be created during one session.

### Commands

| Command | Description |
|---|---|
| `start <seconds>` | Start a worker that runs for the given number of seconds. |
| `list` | Display each task's ID, PID, state, and progress. |
| `pause <id>` | Pause a running task by sending it `SIGSTOP`. |
| `resume <id>` | Resume a stopped task by sending it `SIGCONT`. |
| `terminate <id>` | Terminate an active task by sending it `SIGTERM`. |
| `help` | Display the available commands. |
| `quit` | Terminate remaining workers, collect them, and exit. |

The ID used by TaskWatch is different from the process ID (PID). Commands such as `pause` and `resume` use the TaskWatch ID shown in the first column of `list`.

### Task states

The `list` command may show the following states:

- `RUNNING`: the worker is currently allowed to run.
- `STOPPED`: the worker has been paused.
- `TERMINATING`: TaskWatch has requested termination and is waiting for the child to exit.
- `COMPLETED`: the worker finished normally.
- `FAILED`: the worker exited with an error.
- `TERMINATED`: the worker was ended by a signal.

### Viewing process states with `top`

TaskWatch prints the worker's operating-system PID when a task starts. In another terminal, monitor that process with:

```sh
top -p <PID>
```

Look at the `S` column in `top`:

- After `start` or `resume`, the worker normally shows `S` because it sleeps between progress updates. It may briefly show `R` while executing.
- After `pause`, it should show `T`, meaning stopped.
- After `terminate` or normal completion, the process should disappear because TaskWatch has reaped it.

TaskWatch's `RUNNING` state means the worker is active and allowed to run; it does not mean the process is using the CPU at every instant.

## Example 1: A Task Completes Normally

In this example, a three-second task is started and allowed to finish:

```text
$ ./taskwatch
TaskWatch process supervisor
Type "help" for available commands.

taskwatch> start 3
Started task 1 with PID 4210 for 3 seconds.
taskwatch> list
ID   PID     STATE        PROGRESS   RESULT
1    4210    RUNNING      1/3        -
taskwatch> list
ID   PID     STATE        PROGRESS   RESULT
1    4210    COMPLETED    3/3        exit 0
taskwatch> quit
All child processes have been reaped.
```

The first `list` is entered while the worker is still running. The second is entered after the worker finishes.

## Example 2: Pause, Resume, and Terminate a Task

This example controls a longer-running task with signals:

```text
$ ./taskwatch
TaskWatch process supervisor
Type "help" for available commands.

taskwatch> start 20
Started task 1 with PID 4257 for 20 seconds.
taskwatch> pause 1
Pause requested for task 1.
taskwatch> list
ID   PID     STATE        PROGRESS   RESULT
1    4257    STOPPED      2/20       -
taskwatch> resume 1
Resume requested for task 1.
taskwatch> terminate 1
Termination requested for task 1.
taskwatch> list
ID   PID     STATE        PROGRESS   RESULT
1    4257    TERMINATED   4/20       signal 15 (Terminated)
taskwatch> quit
All child processes have been reaped.
```

Process IDs and progress values will differ between runs. Process scheduling also means a state change may take a brief moment to appear in `list`.

## Source Files

### `taskwatch.c`

Implements the interactive parent/controller. It reads commands from standard input, installs the signal handlers, and uses `select()` to monitor both terminal input and worker progress. It delegates process operations to the process manager.

### `process_manager.c`

Implements process creation and lifecycle management. It creates the status pipe, launches workers with `fork()` and `execvp()`, redirects their standard streams, sends signals with `kill()`, records progress, interprets `waitpid()` results, and cleans up remaining children during shutdown.

### `worker.c`

Implements the child process. A worker sleeps for one second per unit of work and sends a fixed-size progress message through its redirected standard output after each completed second.

### `process_manager.h`

Defines the shared task states, task records, worker status messages, manager structure, constants, and process-manager function declarations used by the C files.

### `Makefile`

Contains the commands used by `make` to compile the `taskwatch` and `worker` executables and to remove generated build files.

## Exiting Safely

Use `quit` to exit TaskWatch. Pressing Ctrl-C also requests an orderly shutdown. In either case, TaskWatch terminates any remaining workers and calls `waitpid()` so that no child process is left as a zombie.
