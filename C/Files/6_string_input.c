#include<stdio.h>
#include<string.h>

int main()
{
	char name[30];

/*
	//Using scanf and printf for strings
	printf("Enter Name: ");
	scanf("%s", name); //Notice the format specifier and no '&' before variable name

	printf("Your name is %s\n", name);//Give the input with spaces and check the output
*/
	
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/*
	//Using gets and puts for strings
	printf("Enter Name: ");
    gets(name); //Avoided in C as there is no buffer bound (function doesn't know how big the input is)
    
    printf("%d\n", (int)strlen(name));
    
    printf("Your name is ");
	puts(name); //Adds an extra newline character ('\n') at the end

    printf("Exiting the program\n");
*/

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/*
	//Clearing the input buffer
	//fflush(stdin); //Avoided as it has undefined behavior and makes the code not portable. 
                     //C standard defines fflush() to be used for output stream.
	
	//OR a better approach is: 
	while ((getchar()) != '\n'); //Reads the buffer characters till the end and discards them (including newline)
*/

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/*  
    //Using fgets and fputs for strings
	printf("Enter Name: ");
	fgets(name, sizeof(name), stdin); //fgets() takes the new line at the end of the string
	
	printf("%d\n", (int)strlen(name));
	
	name[strlen(name)-1]='\0'; //Removes the new line that fgets enters
	
	printf("%d\n", (int)strlen(name));

	fputs(name,stdout); 
	//OR
	printf("%s", name);

	printf("Exiting the program\n");

*/	

	return 0;
}