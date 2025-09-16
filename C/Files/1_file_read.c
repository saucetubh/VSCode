/*
- Till now for the programs that you run, the data is lost after the program execution.
- This is because the memory for the program is deallocated after the program run.
- What if you want to store that data permanently?
- You need to write the data to a file on disk.
- Therefore, you need to know about file handling operations in C
*/

#include<stdio.h>

int main()
{
    //In C, a file is a stream of characters ending with 'EOF' -- It is a negative number.

    char *filename = "sample.txt"; //arrays and pointers are the same

    //FILE is a struct defined in stdio.h
    FILE * fp;

    //Open the file in "r" (READ) mode. Returns the pointer to the first character
    //If the file does not exist, fopen() returns NULL.
    fp = fopen(filename, "r");

    if (!fp) //OR if(fp == NULL)
    {
        printf("Cannot open the file");
        return -1; //Return something other than 0
    }

    //fgetc() reads one unsigned character from the input stream at the current position 
    //and increases the file pointer. It returns the character as an int.

    int ch = fgetc(fp); //Reads the first character of the file since that's where fp is pointing to and also moves the file pointer to next character.
    while(ch != EOF)
    {
        printf("%c", ch);
        ch = fgetc(fp);
    }

    //Closes the file. Releases the memory of the file.
    fclose(fp);
    return 0;
}
