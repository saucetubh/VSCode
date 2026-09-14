#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define PROC_ID 2
#define EXIT_CODE 7

int main(void) {
    setvbuf(stdout, NULL, _IOLBF, 0);
    printf("P%d START\n", PROC_ID);
    sleep(1);
    exit(EXIT_CODE);
}
