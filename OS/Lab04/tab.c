#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define LINES 5   /* how many lines of HTML the page has */
#define THREADS 3 /* how many threads work inside one tab */

/* Shared by every thread of this tab. */
char page[LINES][64];
int next_line = 0; /* the line the next edit goes to */
long updates = 0;

pthread_mutex_t page_lock = PTHREAD_MUTEX_INITIALIZER;

volatile sig_atomic_t running = 1; /* set to 0 when the browser closes us */
int tab_id;

void stop_now(int sig) {
  (void)sig;
  running = 0;
}

/* Returns the thread number written in a line, or -1.
 * In the format, %*d reads a number and throws it away, %d keeps it. */
int owner_of(const char *line) {
  int t = -1;
  sscanf(line, "<p>tab %*d edited by thread %d", &t);
  return t;
}

void *editor(void *arg) {
  int me = *(int *)arg;

  while (running) {
    /* ================= TODO - PART C =================
     * One edit of the page. Every thread of this tab runs this same code
     * at the same time, on the same page[] and the same next_line.
     *
     *  - Store the line number that the shared cursor variable next_line points at
     *    in a local variable called line. That is the line number the thread edits.
     *
     *  - Write the ID of the thread into that line of the page. 
     *    The write should be of this format:
     *      snprintf(page[line], sizeof page[line],
     *               "<p>tab %d edited by thread %d</p>", tab_id, me);
     * 
     *    snprintf takes the arguments: target, buffer size, string as in printf.
     *
     *  - Count the number of edits in the page by incrementing updates.
     *
     *  - The edit takes some time: So, sleep for 1 second.
     *
     *  - Move the cursor on, so that the next thread takes the next line.
     *    After the last line of the page it must go back to line 0.
     *
     *  - Read your line back with owner_of(). If the thread number it
     *    returns is not yours, another thread wrote over your edit while
     *    you were working. Report it with exactly this line:
     *
     *      printf("[tab %d] LOST: thread %d lost line %d -> %s\n",
     *             tab_id, me, line, page[line]);
     *
     *  - Report the edit itself with exactly this line:
     *
     *      printf("[tab %d] thread %d wrote line %d\n", tab_id, me, line);
     *
     * Write it WITHOUT any lock first and run it. Then read task C2 in the
     * README.
     */

    /* ================= END TODO ================= */

    sleep(1); /* thinking time, outside anything you lock */
  }
  return NULL;
}

int main(int argc, char *argv[]) {
  pthread_t th[THREADS];
  int id[THREADS], i;

  if (argc < 2) {
    fprintf(stderr, "usage: ./tab <id>\n");
    return 1;
  }
  tab_id = atoi(argv[1]);

  setvbuf(stdout, NULL, _IONBF, 0);
  signal(SIGTERM, stop_now); /* the browser asks us to close with SIGTERM */

  for (i = 0; i < LINES; i++)
    snprintf(page[i], sizeof page[i], "<p>empty</p>");

  /* ================= TODO - PART B =================
   * Start THREADS threads. They all run the same function, editor.
   *
   *  - Every thread must know its own number. 
   *
   *  - Create each thread with pthread_create. It needs four arguments: 
   *    address of the handle of the new thread, 
   *    NULL for default attributes, 
   *    the function the thread should execute, and 
   *    the argument of the function.
   * 
   *  - Think what the argument of the function should be.
   *    Should you pass the address of loop variable directly? 
   *    What happens if you pass the address of the loop variable: 
   *    All the threads would then look at
   *    the same piece of memory and read the same number.
   *    How can you pass the argument then?
   *
   *  - A new thread starts running at once and on its own. 
   *    You cannot schedule the threads: 
   *    that is the operating system's decision.
   *
   *  - After all threads are created, 
   *    wait for every thread to finish with pthread_join.
   *
   */

  /* ================= END TODO ================= */

  printf("[tab %d] final page:\n", tab_id);
  for (i = 0; i < LINES; i++)
    printf("[tab %d]   line %d: %s\n", tab_id, i, page[i]);
  printf("RESULT tab %d updates %ld\n", tab_id, updates);
  return 0;
}
