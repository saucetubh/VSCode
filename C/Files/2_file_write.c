#include<stdio.h>
#include<stdlib.h>

int main()
{
    char src[FILENAME_MAX], dst[FILENAME_MAX];
    //FILENAME_MAX is a constant to define the maximum number of characters in a filename.

    /*
    //OR have this as src and dst:
    char *src = malloc(FILENAME_MAX*sizeof(char)); 
    char *dst = malloc(FILENAME_MAX*sizeof(char)); 
    */

    FILE *fp1, *fp2;

    printf("Enter the source file name: ");
    scanf("%s", src);
    
    //Can combine fopen() and checking for errors in one line 
    if (!(fp1 = fopen(src, "r")))
    {
        printf("%s: No such file or directory\n\n", src);
        return -1;
    }
    
    printf("Enter the destination file name: ");
    scanf("%s", dst);
    
    //fopen() in "w" (WRITE) mode. 
    //Searches file. If the file exists already, its contents are overwritten. 
    //If the file doesn't exist, a new file is created.
    if (!(fp2 = fopen(dst, "w")))
    {
        printf("Cannot open %s for writing\n\n", dst);
        return -2; //A different error code for writing.
    }

    int count = 0; //to count the number of lines in the file.

    //fputc() writes the given character to the output stream.
    //Writes at the position denoted by the file pointer.
    //And then advances the file pointer. 
    int ch = fgetc(fp1);

    while(ch != EOF)
    {
        fputc(ch, fp2);
        if(ch == '\n')
            count++;
        ch = fgetc(fp1);
    }
    rewind(fp1);
    char line[100];
    int counter = 0;
    while(fgets(line, 100, fp1)) {  //fgets reads from the input stream till it encounters \n, EOF or the length specified is met (n-1), whatever happens first. Then copies it to the string.
        fputs(line, fp2); //fputs writes the string to the output stream till it encounters \0.
        counter++;
    }
    fseek(fp1, 0, SEEK_SET);
    char line1[100];
    fgets(line1, 5, fp1);
    fprintf(stdout, "%s\n", line1);
    printf("%c\n", fgetc(fp1));
    //Closes the file. Releases the memory of the file.
    fclose(fp1);
    fclose(fp2);

    printf("Copied %d lines \n", counter);
    return 0;
}

//for all these functions the pointer is pointing to simply the next unread character
