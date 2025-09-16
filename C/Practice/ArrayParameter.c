#include<stdio.h>

// void display(int arr[2][3])
// void display(int arr[][3])
void display(int (*arr)[3])
{
    printf("\nDisplaying elements: \n");
    for(int i = 0; i < 2; i++)
    {
        for(int j = 0; j < 3; j++)
        {
            printf("%d ", arr[i][j]);
        }
        printf("\n");
    }

    printf("\nDisplaying elements by pointer notation: \n");
    for(int i = 0; i < 2; i++)
    {
        for(int j = 0; j < 3; j++)
        {
            printf("%d ", *(*(arr+i)+j));
        }
        printf("\n");
    }
}
// /*

/*
void display1(int *arr)
{
    printf("\nDisplaying elements by pointer notation: \n");
    for(int i = 0; i < 2; i++)
    {
        for(int j = 0; j < 3; j++)
        {
            printf("%d ", *(arr+3*i+j));  //this is the way to access elements of 2d array using single pointer because the array is stored in row major order
        }   //since arr is a single pointer to the first element, arr + 1 gives us the address of the second element, in the same row, not the next row so to move rows we do 3*i 
        printf("\n");                        
    }
}
// */

int main()
{
    int arr[2][3] = {{1,2,3},{4,5,6}};
    //display(arr);
    display(arr);
    return 0;
}

// *(*(arr+i)+j) is same as arr[i][j] and works only when the parameter beingg passes is a double pointer, and dma is used

