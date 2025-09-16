#include<stdio.h>
#include<limits.h>
#include<stdbool.h>

int main()
{
    printf("Size of int = %d bytes\n", sizeof(int));
    printf("Size of double = %d bytes\n", sizeof(double));
    printf("Size of char = %d bytes\n", sizeof(char));
    printf("Size of bool = %d bytes\n", sizeof(bool));

    printf("INT Range = %d to %d\n", INT_MIN, INT_MAX);
    printf("INT MAX + 3 = %d\n", INT_MAX + 3);

    int x = 10;
    double y = 13.0;
    printf("sizeof(int + double) = %d\n", sizeof(x+y));

    return 0;
}