#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_TABS 8
#define QUANTUM 2 /* one time slice, in seconds */
#define ROUNDS 3  /* how many times we go around the list of tabs */

int main(int argc, char *argv[]) {
  pid_t tab[MAX_TABS];
  int n = 3, active = 0, i, round;

  if (argc >= 2)
    n = atoi(argv[1]); /* how many tabs */
  if (argc >= 3)
    active = atoi(argv[2]); /* which tab the user sees */
  if (n > MAX_TABS)
    n = MAX_TABS;
  for (i = 0; i < MAX_TABS; i++)
    tab[i] = -1; /* "no tab here yet" */

  setvbuf(stdout, NULL, _IONBF, 0); /* print immediately, do not buffer */

  for (i = 0; i < n; i++) {
    char id[8];
    char *args[3];
    snprintf(id, sizeof id, "%d", i);
    args[0] = "./tab"; /* program to run, tab number, end of list */
    args[1] = id;
    args[2] = NULL;

    /* ================= TODO - PART A1 =================
     * Create one tab process and freeze it at once.
     *
     *  - Call fork() and keep the returned process id in tab[i].
     *    fork() makes a copy of this process. In the copy it returns 0,
     *    in the parent it returns the process id of the copy.
     *
     *  - Only the copy (the child) should become a tab. In it, replace the
     *    running program with a new one by calling execvp: it takes the
     *    program to run and the argument list, both of which are in args.
     *    execvp only returns if it failed, so after it print the reason
     *    with perror and end the child with _exit(1).
     *
     *  - The parent goes on. Freeze the new tab immediately by sending it
     *    SIGSTOP signal. A stopped process stays stopped even while it
     *    is starting a new program, so this is safe to do straight away.
     *
     */
    
    /* ================= END TODO ================= */
  }

  /* Without this, a missing Part A1 would send signals to pid -1. */
  for (i = 0; i < n; i++)
    if (tab[i] <= 0) {
      fprintf(stderr,
              "[sched] no tabs were created. Finish Part A1 in rr.c first.\n");
      return 1;
    }

  printf("[sched] policy = round robin, %d tabs, active tab = %d, quantum = %d "
         "s\n",
         n, active, QUANTUM);

  for (round = 0; round < ROUNDS; round++) {
    /* ================= TODO - PART A2 =================
     * ROUND ROBIN: every tab gets a turn, in the order 0, 1, 2, ... n-1,
     * and then it starts again. The active tab is the one the user is
     * looking at, so it gets TWICE the time slice of the others.
     *
     * For each tab, in order:
     *
     *  - Work out how many seconds it runs: two quanta if it is the active
     *    tab, one quantum otherwise.
     *
     *  - Print this line, exactly as written, 
     *    by replacing the <> with correct format specifiers and variables. 
     *    check.sh reads it to see the
     *    order and the length of your slices:
     *
     *      printf("[sched] round <round>: tab <tab-id> runs for <time> s\n", round, i, secs);
     *
     *  - Let the tab run: send it SIGCONT signal.
     *
     *  - Tha parent goes to the blocked state for that many seconds. 
     *    The parent has nothing else to do,
     *    and the tab is the only process working while you sleep.
     *
     *  - Freeze the tab again: send it SIGSTOP signal.
     *
     */

    /* ================= END TODO ================= */
  }

  /* Wake every tab, give it a second to install its handler, then close it. */
  for (i = 0; i < n; i++)
    kill(tab[i], SIGCONT);
  sleep(1);
  for (i = 0; i < n; i++)
    kill(tab[i], SIGTERM);
  for (i = 0; i < n; i++)
    wait(NULL);
  printf("[sched] all tabs closed\n");
  return 0;
}
