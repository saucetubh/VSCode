#include<stdio.h>

int main()
{
    char *name = "CPisTheBest"; //pointer to a string
    printf("%s\n", name); //prints the string
    printf("%c\n", *name); //dereferencing
    printf("%c\n", *(name+1)); //pointer arithmetic
    printf("%c\n", name[2]); //array notation
    printf("%c\n", *name + 2); //dereferencing and arithmetic
    printf("%s\n", name + name[2] - name[6]); //pointer arithmetic
}

