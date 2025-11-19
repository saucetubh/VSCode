#include <stdio.h>
int main() {
    int num1, num2, num3, max;

    // Input three numbers
    printf("Enter three numbers: ");
    scanf("%d %d %d", &num1, &num2, &num3);

    // Find the maximum
    if (num1 > num2 && num1 > num3) {
        max = num1;
    } else if (num2 > num3) {
        max = num2;
    } else {
        max = num3;
    }

    // Output the result
    printf("The maximum of the three numbers is: %d\n", max);

    return 0;
}

