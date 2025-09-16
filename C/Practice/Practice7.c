#include <stdio.h>

void decimalToBinary(int n) {
    if (n > 1)
        decimalToBinary(n / 2);
    
    printf("%d", n % 2);
}

int main() {
    int decimalNumber;
    
    printf("Enter a decimal number: ");
    scanf("%d", &decimalNumber);
    
    printf("Binary equivalent: ");
    decimalToBinary(decimalNumber);
    printf("\n");
    return 0;
}