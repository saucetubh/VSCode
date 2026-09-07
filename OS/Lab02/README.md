# Process Task Manager

## Overview

Complete a small process manager in C. It reads commands from a file and
creates and manages child processes for each task.

There are two kinds of task:

- **Sleep tasks** run for a set amount of *active* time.
- **Exec tasks** turn the child into one of a few external programs.

The assignment is about process creation, process control, and cleaning up
child processes.

## Task types

- `start s5` — a sleep task that should run for 5 seconds of **active**
  execution time. Time spent paused does not count.
- `start e1` — an exec task that runs one of the external programs listed in
  the `exec_options` table.

## Commands

| Command | Effect |
|---------|--------|
| `start s<n>` / `start e<n>` | Start a new task (sleep or exec). |
| `pause <id>` | Stop a task where it is, without destroying it. |
| `resume <id>` | Wake a paused task back up. |
| `terminate <id>` | Stop a task for good and clean up its child. |
| `wait <n>` | Parent sleeps `n` seconds. (Already implemented.) |

Every task gets a unique ID. Each prints a timestamped line for events like
start, pause, resume, terminate, and exit.

## What you implement

The starter code has TODOs (`YOUR CODE HERE`) you need to fill in. Some are
whole functions, and one is a partly-written function. Implement each one,
using the provided helpers (`find`, `reap_all`, `custom_sleep`). What each
should do:

- **`worker`** — for a sleep task it just waits; that part is given. For an
  exec task, the child turns itself into the external program from
  `exec_options`. Hint: when that works, the child never comes back.
- **`cmd_start`** — make a child, run it, and record it in the task table.
  Hint: the parent and child both keep running after this.
- **`check_status`** — partly given. Fill in the check for whether the child
  has exited, and update the task's status/end time when it has. Hint: a
  `waitpid()` call both checks and reaps; use `get_time()` for the timestamp.
- **`cmd_terminate`** — stop and reap a task. Hint: a signal kills it; the
  child must then be reaped.
- **`cmd_pause`** — suspend a task in place. Hint: a signal can freeze a
  running process.
- **`cmd_resume`** — restart a paused task. Hint: a signal wakes it back up.

The `pause`/`resume`/`terminate` functions should silently ignore requests
for tasks that don't exist or already finished.

## Provided helpers

- `find(id)` — index of a task, or -1.
- `reap_all()` — checks all tasks after each command.
- `custom_sleep()` — handles active-time timing for sleep tasks.

Don't redesign these; follow the state updates the code expects
(`RUNNING`, `PAUSED`, `TERMINATED`, `DONE`).

## Build and run

Build and test with the provided Makefile:

```sh
# runs all test cases sequentially
make test
```

Run the program on a command file if you want to try a specific case
yourself:

```sh
./task_manager test/<test_case_file>
```

## Autograder

Use the following command to run the autograder
```sh
make grade 
#OR
python3 autograder.py
```

## Testing

Test each behavior on its own first, then together: a basic sleep task, two
tasks at once, pause then resume, terminate, pause then terminate, and an
exec task.

Cover the race case where a worker finishes right as another command acts
on it — the program must not crash or corrupt task state.

## Constraints

- Every task must be its own child process; the parent keeps running.
- Terminated and finished children must be reaped (no zombies).
- Paused time must not count toward a sleep task's active time.
- Don't hard-code behavior for specific test cases.

Consult the man pages (`man 2 <syscall>`) for the mechanisms you need —
which ones to use is part of the task.
