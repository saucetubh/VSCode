#include<stdio.h>

int main()  {
    int i=22;
    int j=7;
    int rem = i%j;
    printf("i = %d\n", i++);
    printf("i = %d\n", ++i);
    printf("i = %d\n", i);
    printf("Remainder is %d\n", rem);
    printf("i<j = %d\n", i < j); 

    return 0;
}