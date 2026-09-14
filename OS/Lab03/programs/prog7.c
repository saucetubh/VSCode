#include <stdio.h>
#include <unistd.h>

#define PROC_ID 7
#define TOTAL_TICKS 6

int main(void) {
    setvbuf(stdout, NULL, _IOLBF, 0);
    printf("P%d START\n", PROC_ID);
    for (int i = 1; i <= TOTAL_TICKS; i++) {
        sleep(1);
        printf("P%d TICK %d\n", PROC_ID, i);
    }
    printf("P%d END\n", PROC_ID);
    return 0;
}
