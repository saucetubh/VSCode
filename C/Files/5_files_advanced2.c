#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

typedef struct
{
    int id;
    char *name;
    int sub1;
    int sub2;
    double avg;
} student_t;

typedef struct 
{
    student_t *s;
    int count;
}class_t;


class_t* read_list(FILE *fp)
{
    class_t* c = malloc(sizeof(class_t));

    char line[100];
    c->count = 0;
    while (fgets(line, 100, fp) != NULL)
        c->count++;

    printf("Number of lines = %d\n", c->count); 

    c->s = malloc(c->count * sizeof(student_t));   

    //rewind(filePointer) take the file pointer to the beginning of the file
    rewind(fp);

    int i = 0;
    int roll, subject1, subject2;
    char str[20];

    /*
    fscanf() is similar to scanf() except that it helps inputs things from the file pointer
    It returns the number of fields that it successfully converted and assigned.
    */
    while(fscanf(fp, "%d, %s %d, %d", &roll, str, &subject1, &subject2) > 0)
    {
        printf("%d %s %d %d\n", roll, str, subject1, subject2);
        c->s[i].id = roll;
        c->s[i].name = calloc(strlen(str)+1, sizeof(char));
        strcpy(c->s[i].name, str);
        c->s[i].sub1 = subject1;
        c->s[i].sub2 = subject2;
        c->s[i].avg = (subject1+subject2)/2.0;
        i++;
    }

    return c;
}

void fprint_list(FILE *fp, class_t* c)
{
    int i = 0;
    while (i < c->count)
    {
        fprintf(fp, "%d, %s %d, %d, %.1lf\n", c->s[i].id, c->s[i].name, c->s[i].sub1, c->s[i].sub2, c->s[i].avg);
        ++i;
    }
}

int main()
{
    char *fname = "student.txt";

    FILE *fp;
    if (!(fp = fopen(fname, "r")))
    {
        printf("%s: No such file or directory\n\n", fname);
        return -1;
    }

    class_t* c = read_list(fp);

    fclose(fp);

    fp = fopen(fname, "w");
    if (fp)
    {
        fprint_list(fp, c);
    }
    fclose(fp);

    return 0;
}