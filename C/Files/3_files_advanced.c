#include<stdio.h>
#include<string.h>

int main()
{

	FILE* fp;

	//Open an existing file in 'r+' mode - opened for both read and write
	//If file doesn't exist, it will return NULL
	//
    //
	//Opening an existing file in 'w+' mode - opened for both read and write
    //Will delete all existing contents of a file
	//But if a file doesn't exist, it will create a new file
    //
    //
    //Opening an existing file in 'a+' mode - opened for both read and write
    //Will create the file if the file does not exist. 
    //Read anywhere in the file. 
    //Writes will always append to the end of the file.
	
    fp = fopen("arnab.txt", "r+");

    int count = 0; //Count the number of characters
    while(fgetc(fp) != EOF)
        count++;

	//fseek(filePointer, int offset, int position) 
	//to move the cursor by an offset 
	//from the position defined by the following constants:
	//SEEK_SET = Beginning of the file
	//SEEK_CUR = Current Position of the file pointer
	//SEEK_END = End of FILE   

	fseek(fp, count, SEEK_SET);

	//Write into the file
    //fputs(const char *str, FILE *stream) writes str to the stream up to but not including the null character.
	fputs(" Paul!\n", fp);


	//Go back to the starting of the file so that we can print it
	fseek(fp, 0, SEEK_SET); //or rewind(fp)

	char read[20];

	//Reading the file 20 characters at a time
	while(fgets(read, 20, fp) != NULL)
	{
		printf("%s", read);
	}

	//If you want to append at the end of the file,
	//set the cursor at the end of the file by:
	fseek(fp, 0, SEEK_END);

	fputs("I teach CP.\n", fp);
	
	//Close the file
	fclose(fp);

	return 0;
}