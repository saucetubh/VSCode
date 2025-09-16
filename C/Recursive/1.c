#include<stdio.h>

void print1(char c, int n) {
    if (n>1)
        print1(c-1, n-1);
    printf("%c", c);
}
void print2(int n) {
    if (n>1)
        print2(n-1);
    print1('0' + n, n);
    printf("\n");
}

int main() {
    print2(4);
    return 0;
}