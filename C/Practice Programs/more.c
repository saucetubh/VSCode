#include<stdio.h>

int main() {
    int a = 010;  // 0 before a number makes it octal
    int b = 0x10; // 0x before a number makes it hexadecimal
    int c = 10;  // No prefix makes it decimal
    printf("%d %d %d\n", a, b, c);  
    printf("%o %x %d\n", a, b, c); // %o prints octal, %x prints hexadecimal, %d prints decimal
}
