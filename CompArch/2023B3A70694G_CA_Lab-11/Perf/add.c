#include <stdio.h>
#include <stdlib.h>

#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)

long rand_partsum(int n) {
    int i, k;
    long sum = 0;
    long final_sum = 0;
    int *vec = (int *)malloc(n * sizeof(int));

    for (i = 0; i < n; i++)
        vec[i] = rand() % n;

    for (i = 0; i < n; i++)
        sum += (vec[i] > n / 2) * vec[i];

    for (k = 0; k < 1000000; k++)
        final_sum += sum;

    return final_sum;
}

int main() { rand_partsum(2000); }