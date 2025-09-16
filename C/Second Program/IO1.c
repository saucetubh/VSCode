/*
#include <stdio.h>
int main() {
    int x, y;
    printf("Enter two integer numbers: ");
    scanf("%d %d", &x, &y);
    printf("Is x>y: %d\n", x>y);       // output of 1 implies true, 0 implies false
    printf("Is x<y: %d\n", x<y);
    printf("Is x=y: %d\n", x==y);
    return 0;
}
*/

#include <stdio.h> 
#include <string.h> 
#define BUFFER_SIZE 15 
int main() 
{ 
	char str[BUFFER_SIZE]; 
	printf("Enter the data = "); 
	if (fgets(str, sizeof(str), stdin) == NULL) { 
		printf("Fail to read the input stream"); 
	} 
	else { 
		str[strlen(str)] = '\0'; 
	} 
	printf("Entered Data = %s\n", str); 
	return 0; 
}

//this lets you take string input with whitespaces, and it will read the entire line, including the whitespaces