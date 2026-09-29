# Lab: A Browser that Schedules its Tabs

## 1. Problem

A browser runs every tab as a separate **process**. They all want the CPU, but the tab you
are looking at (the **active tab**) must feel fast, so it should get more CPU time than the
others. You are tasked to write two schedulers to schedule the tabs (processes), with two different rules.

Moreover, inside each tab there are several **threads**. 
This is also a practical example as a browser tab editing images draws a HTML page, runs JavaScript and waits for images at the same time. All threads of that tab edit the **same memory block of that page**. A sub-example of this needs to be coded in second half of today's lab.

Two different schedulers are at work here, and they are easy to mix up:

| What | Who decides |
|---|---|
| which **tab** (process) runs | your scheduler code |
| which **thread** inside a tab runs | the operating system |

So the scheduler lines in the output are always the same, while the tab lines come out in a
different order on every run. That is normal, not a bug.

## 2. Tasks

| Task | File | What you write | Approx Lines of Code |
|---|---|---|---|
| A1 | `rr.c` | create the tab processes | 7 |
| A2 | `rr.c` | share the CPU in round robin | 6 |
| B | `tab.c` | create the threads | 6 |
| C | `tab.c` | edit the shared page, then protect it from contention | 8 |
| D | `priority.c` | priority scheduling to share the cpu, then implement aging | 9 |

Each file has a `TODO` block that says what to do. Do the tasks in the order (A-D).

You can check your implementation using the steps below.

```sh
make              # builds ./rr, ./priority and ./tab
./rr 3 0          # 3 tabs, tab 0 is the active one
./priority 3 0    # 3 tabs, tab 0 is the active one
sh check.sh       # runs the autograder
make clean        # removes the binary files
```

One time slice is 2 seconds, so a run takes about 20 seconds. Everything waits with
`sleep()`, in whole seconds. Thus, the autograder script will take some amount of time to run.

## 3. The tasks in detail

### A1 - create the tab processes (`rr.c`)

`fork()` copies the browser process, `execvp()` turns the copy into the program `./tab`,
and `SIGSTOP` freezes it at once so nothing runs until your scheduler allows it.

Before this task, `./rr 3 0` refuses to start: no tabs exist, and sending signals to
processes that are not there would hit everything you own.

**Check:** `./rr 3 0` no longer complains, and each tab prints its page and
`RESULT tab N updates 0`.

### A2 - round robin (`rr.c`)

Every tab gets a turn, in the order 0, 1, 2, ... and then it starts again. The active tab
gets a **double** slice. Use `SIGCONT` to let a tab run, `sleep()` while it works, and
`SIGSTOP` to freeze it again. Keep the `printf` exactly as given: the autograder reads it.

**Check:**

```
[sched] round 0: tab 0 runs for 4 s
[sched] round 0: tab 1 runs for 2 s
[sched] round 0: tab 2 runs for 2 s
[sched] round 1: tab 0 runs for 4 s
```

Each tab will also print its page once and then finish, and rounds 1 and 2 will look empty.
That is correct for now: without task B a tab has no threads, so it ends during its first
slice.

### B - start the threads (`tab.c`)

Create `THREADS` threads running the `editor` function, then wait for them with
`pthread_join`. Thread `i` must receive `&id[i]`, **not** `&i`: both compile, only one is
correct.

**Check:** `./rr 3 0` now takes about 20 seconds instead of ending at once.

### C - edit the page (`tab.c`)

**C1, no lock.** All threads share the array `page[]` and the cursor `next_line`. Each
thread takes the line the cursor points at, writes its name there, and moves the cursor on.
Write it without any lock and run it:

```sh
./rr 3 0 > bad.txt
grep -c "LOST" bad.txt         # about 30
grep -c "wrote line" bad.txt   # about 45
```

Two of every three edits are destroyed: two threads read the same `next_line` before either
moves it, write to the same line, and only the last one survives.

**C2, with the lock.** 
Read the man page for `pthread_mutex_lock` by typing
```sh
man 3 pthread_mutex_lock
```

Put `pthread_mutex_lock(&page_lock);` before your first line and
`pthread_mutex_unlock(&page_lock);` after your last one. Now `./rr 3 0 | grep -c LOST`
must be 0. Leave the `sleep(1)` at the bottom outside the lock: a lock should be held for
as short a time as possible.

### D - priority scheduling (`priority.c`)

A second, independent browser. Round robin asks *whose turn is it*; this one asks *who is
most important*. Each tab has a number in `prio[]`, and the active tab starts higher.

**D1:** run the tab with the highest priority. Result:

```
RESULT tab 0 updates 26
RESULT tab 1 updates 3
RESULT tab 2 updates 3
```

One tab takes everything. This is **starvation**. (The 3 edits are from the last second at
shutdown, when every tab is woken up to close.)

**D2:** add aging, so a tab that keeps waiting slowly becomes more important. Result:

```
RESULT tab 0 updates 17
RESULT tab 1 updates 8
RESULT tab 2 updates 6
```

Nobody starves, and the active tab still gets the most.

## 4. The autograder

Check the entire code using.

```sh
sh check.sh
```

9 checks, about a minute. Each FAIL line says what was expected and what your program did.

Only one check is an exact comparison: the order and length of your slices in `rr`, which
your code alone decides. It is shown as a `diff` when it fails. The other checks are about
the *kind* of result, because the operating system decides which thread runs and how many
edits fit into a slice: every tab did some work, the active tab did clearly more, nothing
was lost, nobody starved.

This is also why the counts are not exactly 2 to 1. Waiting happens in whole seconds, and
every tab gets the same last second to close, which lifts the small numbers more than the
big one. 14 / 9 / 8 is a correct result.

## 5. Debugging

**Rebuild first.** If nothing changed, run `make` and check that it really recompiles.
No `[sched] round ...` lines at all means the program you ran does not contain your task A2.

**Watch the tabs.** While `./rr 3 0` runs, in a second terminal:

```sh
ps ax -o pid,stat,command | grep "[.]/tab"
```

```
18736 T+   ./tab 0
18737 T+   ./tab 1
18738 S+   ./tab 2
```

Only the **first letter** of `STAT` matters: `T` is stopped (your `SIGSTOP`), `S` or `R` is
running. Anything after it can be ignored (`+` foreground, `l` several threads). Exactly one
tab is out of `T` at any moment, and it changes every 2 seconds.

**Compare the slices yourself.** This is what the exact check does:

```sh
./rr 3 0 | grep '^\[sched\] round [0-9]' | sed 's/^.*: //' > mine.txt
```

With 3 tabs and tab 0 active, `mine.txt` must hold `tab 0 runs for 4 s`,
`tab 1 runs for 2 s`, `tab 2 runs for 2 s`, three times over. Put that in `want.txt` and run
`diff want.txt mine.txt`. Do not try this with the tab lines: two runs will always differ.

| Problem | Likely cause |
|---|---|
| `no tabs were created` | task A1 is not written |
| No `[sched] round ...` lines | the binary has no task A2 in it: run `make` |
| Tabs end in round 0, later rounds empty | normal until task B |
| `execvp: No such file or directory` | `./tab` was not built: run `make` |
| Tabs print nothing | no `SIGCONT`, or no `sleep` before `SIGSTOP` |
| All tabs print together | missing `SIGSTOP` at the end of the slice |
| Program hangs, prints nothing | you locked the mutex but never unlocked it |
| Every line says the same thread number | you passed `&i` instead of `&id[i]` |
| LOST lines after adding the lock | the lock does not cover all of your task C code |
| `priority`: only the active tab runs | the aging lines are missing |
| Tabs left frozen after Ctrl-C | `pkill -CONT tab; pkill tab` |

The starting code gives 6 warnings about unused variables. They disappear as you write the
tasks that use them.
