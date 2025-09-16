#include<stdio.h>

int decimalToBinary(int decimal) {
    if (decimal == 0) {
        return 0;
    }
    return (decimal%2) + (10*decimalToBinary(decimal/2));
}

char calculator(int balance) {  
    char option; 
    int value;
    printf("Balance: %d\n", balance);
    scanf(" %c",&option);
    if (option == '+') {
        scanf("%d",&value);
        char x = calculator(balance+value);
        if (x == 'c') {
            calculator(balance);
        }
    }
    else if (option == '-') {
        scanf("%d",&value);
        char x = calculator(balance-value);
        if (x == 'c') {
            calculator(balance);
        }
    }
    else if (option == 'c') {
        return 'c';
    }
    else if (option == 'e') {
        return 'e';
    }
}

int main() {
  printf("1. decimal to binary  2. calculator(0)\n");
  printf("Which function do you want to test? Enter 1 or 2 accordingly.\n");

  int option;
  scanf(" %d", &option);

  if(option == 1)
  {
    int decimal;
    printf("Enter a number between 0 and 1000 (both inclusive): ");
    scanf("%d", &decimal);
    printf("Binary is: %d\n", decimalToBinary(decimal));
  }
  else if(option == 2)
  {
    calculator(0);
  }
  return 0;
}