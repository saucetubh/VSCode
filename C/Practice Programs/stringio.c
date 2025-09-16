#include<stdio.h>
#include<string.h>

int main()
{
    char str1[6] = "Hello";
    char str2[] = "Hello";  // Size automatically calculated
    char str3[6] = {'H', 'e', 'l','\0', 'l', 'o'};
    for (int i = 0; i < 5; i++)
    {
        printf("%c", str3[i]);
    }
    printf("\n");
    for (int i = 0; i < 6; i++)
    {
        printf("%c", str1[i]);
    }
    printf("\n");
    printf("%s\n", str1);
    printf("%s\n", str2);
    printf("%s\n", str3);
}

//printing \0 with %s terminates the string after that character
//printing it with %c prints the null character itself, i.e prints nothing

/*
int main() {
    char str1[100];
    char str2[100];
    printf("Enter two strings: "); 
    scanf("%s %s", str1, str2); // No & before str1 and str2
    printf("You entered: %s and %s\n", str1, str2);
    return 0;    
}
*/
/*
#include <stdio.h>
int main() {
    char ch1, ch2;
    printf("Enter two characters: ");
    scanf(" %c %c", &ch1, &ch2);  //Leading space in format specifier skips white space characters
    printf("You entered: %c and %c\n", ch1, ch2);
}
*/
// %s reads until a white space character is encountered
// %c reads a single character
// %d reads an integer
// %f reads a float
// %lf reads a double
// %x reads a hexadecimal number
// %o reads an octal number