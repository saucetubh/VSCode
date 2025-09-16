#include <stdio.h>

// Structure to represent an operation
typedef struct {
    char op;  // Operation: '+' or '-'
    int val;  // Value for the operation
} Operation;

// Array to store previous operations
Operation operations[100];
int num_operations = 0; // Number of operations stored

// Function to perform arithmetic operations and handle cancellations
char calculator(int balance) {
    printf("Balance: %d\n", balance);
    char option;
    scanf(" %c", &option);

    if (option == 'e') {
        return 'e'; // Exit signal
    }

    if (option == 'c') {
        if (num_operations > 0) {
            Operation last_op = operations[num_operations - 1];
            num_operations--; // Decrement the number of operations

            // Undo the last operation
            if (last_op.op == '+') {
                printf("Canceled addition of %d\n", last_op.val);
                balance -= last_op.val;
            } else if (last_op.op == '-') {
                printf("Canceled subtraction of %d\n", last_op.val);
                balance += last_op.val;
            }
        } else {
            printf("No more operations to cancel.\n");
        }
        return calculator(balance); // Continue with the updated balance
    }

    // For addition and subtraction, store the operation and value, then call calculator recursively with updated balance
    if (option == '+') {
        Operation new_op = { '+', 0 };
        scanf("%d", &new_op.val);
        operations[num_operations++] = new_op;
        return calculator(balance + new_op.val);
    }

    if (option == '-') {
        Operation new_op = { '-', 0 };
        scanf("%d", &new_op.val);
        operations[num_operations++] = new_op;
        return calculator(balance - new_op.val);
    }

    // If an invalid option is entered, prompt the user again
    printf("Invalid option. Please enter '+', '-', 'c', or 'e'.\n");
    return calculator(balance);
}

int main() {
    int balance = 0;
    calculator(balance);
    return 0;
}
