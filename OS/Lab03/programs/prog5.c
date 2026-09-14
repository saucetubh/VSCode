#include <stdio.h>
#include <unistd.h>

#define PROC_ID 5
#define WORK_SECONDS 2

int main(void) {
    setvbuf(stdout, NULL, _IOLBF, 0);
    printf("P%d START\n", PROC_ID);
    sleep(WORK_SECONDS);
    printf("P%d END\n", PROC_ID);
    return 0;
}
