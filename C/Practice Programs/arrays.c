#include <stdio.h>
#include<string.h>
/*
void printArrayAndString(int arr[], char str[]) {  
    printf("Array elements: ");
    for (int i = 0; i < strlen(str); i++) {
        printf("%d ", str[i]);
    }
    printf("\nString: %s\n", str);
}

int main() {
    int array[] = {1, 2, 3, 4, 5};
    char string[] = "Hello, World!";
    for (int i = 0; i < strlen(string); i++) {
        printf("%c ", string[i]);
    }
    printArrayAndString(array, string);
    printf("%d\n", strlen(string)); //it will print the length of the string wihtout null character
    return 0;
}
*/
/*
int main() {
    int x=0;
    if (!printf("Hello ")) {
        x=1;
    }
    else {
        x=2;
    }
    printf("%d\n", x);
}
*/
/*
int main() {
int i = 0;
while (i++ < 5) { //++i would give 1 2 3 4  
    printf("%d ", i);
}
printf("\n");
}
*/
#include<stdio.h>

int sum(int a[], int l)
{
    int s = 0;
    printf("Inside the function\n");
    printf("Size of a = %d\n", sizeof(a));
    printf("Size of a[0] = %d\n", sizeof(a[0]));
    for(int i = 0; i < l; i++)
        s += a[i];  
    return s;    
}

int main()
{

	int len;

	printf("Enter length of the array: ");
	scanf("%d",&len);

	int arr[len];

	for(int i = 0; i < len; i++)
	{
		printf("Enter element %d: ", i);
		scanf("%d", &arr[i]);
	}

	for(int i = 0; i<len; i++)
	{
		printf("%d ", arr[i]);
	}
	printf("\n");
        printf("Size of a = %d\n", sizeof(arr));  

    printf("The sum of all numbers in the array is %d\n", sum(arr, len));

	return 0;
}
