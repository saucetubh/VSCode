#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_TABS 8
#define QUANTUM 2 /* one time slice, in seconds */
#define ROUNDS 4  /* each round hands out n slices */

int main(int argc, char *argv[]) {
  pid_t tab[MAX_TABS];
  int prio[MAX_TABS]; /* bigger number = more important */
  int n = 3, active = 0, i, k, round;

  if (argc >= 2)
    n = atoi(argv[1]);
  if (argc >= 3)
    active = atoi(argv[2]);
  if (n > MAX_TABS)
    n = MAX_TABS;
  for (i = 0; i < MAX_TABS; i++)
    tab[i] = -1;

  setvbuf(stdout, NULL, _IONBF, 0);

  /* Same as Part A1 of rr.c, given here so you do not write it twice. */
  for (i = 0; i < n; i++) {
    char id[8];
    char *args[3];
    snprintf(id, sizeof id, "%d", i);
    args[0] = "./tab";
    args[1] = id;
    args[2] = NULL;

    tab[i] = fork();
    if (tab[i] == 0) {
      execvp(args[0], args);
      perror("execvp");
      _exit(1);
    }
    kill(tab[i], SIGSTOP);
  }

  /* The tab the user is looking at starts as the most important one. */
  for (i = 0; i < n; i++)
    prio[i] = (i == active) ? 3 : 1;

  printf("[sched] policy = priority, %d tabs, active tab = %d, quantum = %d s\n",
         n, active, QUANTUM);

  for (round = 0; round < ROUNDS; round++) {
    /* ================= TODO - PART D =================
     * Hand out n slices in every round; the counter k is there for that.
     * Each time, the tab with the HIGHEST priority is the one that runs.
     *
     * PART D1 - choose and run:
     *
     *  - Find which tab has the highest priority. Let's call it "best".
     *
     *  - Then, print this line, exactly as written:
     *
     *      printf("[sched] round %d: tab %d runs (prio %d)\n",
     *             round, best, prio[best]);
     *
     *  - Run that tab for one quantum.
     *    Remember the SIGCONT, sleep, SIGSTOP steps in the other scheduler.
     *
     *  Run the program now with ./priority 3 0. 
     *  You will notice that one tab takes everything and the
     *  others never run. That is STARVATION.
     *
     * PART D2 - Introducing aging. Still inside the k loop, after the tab has run:
     *
     *  - Once a tab has run, the priority of the tab resets to its original value
     *    (3 for the active tab, 1 for any other).
     *
     *  - Increment by one the priority of every OTHER tab that did not run in the current slice. 
     *    A tab that keeps waiting slowly becomes more important, 
     *    until in one slice, it has the highest priority and gets its turn.
     *
     */

    /* ================= END TODO ================= */
  }

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
