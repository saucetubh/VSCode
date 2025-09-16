#include<stdio.h>
#include<stdlib.h>

int main() {
    // Open a file for writing
    FILE *file = fopen("file.txt", "w");
    if (file == NULL) {
        printf("Failed to open file for writing\n");
        return 1;
    }

    // Write to the file
    fprintf(file, "Hello, World!\n"); //if instead of file, stdout is used, it will print to the console, not the file.

    // Close the file
    fclose(file);

    // Open the file for reading
    file = fopen("file.txt", "a+");  //in a+ mode, to read pointer starts from the beginning of the file but to write pointer starts from the end of the file unless explicitly pointer placed otherwise
    if (file == NULL) {
        printf("Failed to open file for reading\n");
        return 1;
    }  
    fseek(file, 0, SEEK_SET);  
    fputs("I am Arnab\n", file);  // Append to the file from a new line, irrespective of pointer position. Pointer now points to the next line (after writing this)
    // Read from the file
    rewind(file);  // Move the file pointer to the beginning of the file 
    char buffer[100];
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("%s", buffer);
    }

    // Close the file
    fclose(file);

    return 0;
}

//r+ lets you read and write, but it will start overwriting over already written contents from wherever the pointer is set to
//a+ mode will append to the file from a new line, it does not overwrite or delete things, and you can read from it.
//w mode will delete the contents and can write, however you cannot read from it, so fgets doesnt work
//w+ lets you read and write, however it deletes everything first and then begins
//a wont let you read the file
//a and a+ mode will always append to the file from a new line, regardless of where the pointer is, and they always read from the beginnning unless explicitly set otherwise

/*/
FILE *file = fopen("numbers.txt", "r");
int num;
while (fscanf(file, "%d", &num) == 1) {       if fscanf returns 1, it means it has read an integer
    printf("Read number: %d\n", num);
}
fclose(file);

In this code, `fscanf` reads an integer from the file and stores it in `num`. 
The loop continues until `fscanf` fails to read an integer, which could be because it has reached the end of the file 
or because it encountered a non-integer.

instead of file, you can use stdin which is the standard input stream, and it will read from the console (the things you type)
*/