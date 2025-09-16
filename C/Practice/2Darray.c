#include<stdio.h>
#include<stdlib.h>


//2d array using heap and double pointers

int main() {
    int rows = 3;
    int cols = 4;
    int **matrix = (int **)malloc(rows * sizeof(int *)); //double pointer because it is a 2d array, it is a pointer to an array of pointers which point to arrays of integers
    for (int i = 0; i < rows; i++) {
        matrix[i] = (int *)malloc(cols * sizeof(int));
    }

    // Initialize the matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] = i * cols + j;
        }
    }

    // Print the matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d ", matrix[i][j]); // matrix[i][j] is same as *(*(matrix+i)+j)
        }
        printf("\n");
    }

    // Free the memory
    for (int i = 0; i < rows; i++) {
        free(matrix[i]);
    }
    free(matrix);
    return 0;
}

//if i do matrix+1 it basically points to the next row beecause matrix is a pointer to an array of pointers which point to arrays of integers
//similarly matrix[1] is also the same thing, it will point to the second row




