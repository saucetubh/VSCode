#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>

typedef struct
{
  char *name;
  bool alive;
} member_t;

/**
 * @brief Find the first index of 'c' in 's'; -1 if 'c' does not occur in 's'.
 *
 */
int find_index(char *s, char c)
{
  int i = 0;
  while (i < strlen(s) && s[i] != c)
    ++i;
  return s[i] == c ? i : -1;
}

/**
 * @brief Kill the member with the given name in the list.
 *
 */
void kill_by_name(member_t list[], char *name)
{
  int i = 0;
  while (list[i].name != NULL && strcmp(list[i].name, name) != 0)
    ++i;
  list[i].alive = false;
}

/**
 * @brief Read the list from the given file pointer into the given array.
 *
 * Assumes the format of the list is:
 * <name, status>, one  per line, where <status> is 'dead' or 'alive'.
 *
 */
void read_list(FILE *fp, member_t list[])
{
  const int MAX_LENGTH = 80;
  char line[MAX_LENGTH];
  int i = 0;
  /*
  fgets(char *str, int n, FILE *fp) 
  reads a line from the specified file stream (fp) and stores it into the string pointed to by str. 
  It stops when either (n-1) characters are read, the newline character is read, 
  or the end-of-file is reached, whichever comes first.
  */
  while (fgets(line, MAX_LENGTH, fp) != NULL)
  {
    printf("Processing line > %s", line);
    int comma_index = find_index(line, ',');
    printf("Comma Index = %d\n", comma_index);
    list[i].name = malloc((comma_index + 1) * sizeof(char));

    /*
    strncpy(char *dest, char *src, int n)
    Copies upto n characters from the src to dest. 
    If length of src is less than that of n, the remainder of dest will be padded with null bytes.
    */
    strncpy(list[i].name, line, comma_index);
    list[i].name[comma_index] = '\0'; //This statement is needed to stop the name string
    printf("Name ----> %s\n", list[i].name);
    list[i].alive = line[comma_index + 2] == 'a';
    ++i;
  }
}

/**
 * @brief Prints the given list to the given file.
 * 
 */
void fprint_list(FILE *fp, member_t list[])
{
  int i = 0;
  while (list[i].name != NULL)
  {
    /*
    fprintf() is similar to printf() except that it helps prints things to the file pointer
    */
    fprintf(fp, "%s, %s\n", list[i].name, list[i].alive ? "alive" : "dead");
    ++i;
  }
}

/**
 * @brief Prints the given list to the console.
 *
 */
void print_list(member_t list[])
{
  fprint_list(stdout, list);
}

int main()
{
  member_t list[20];
  for(int i= 0; i < 20; i++)
  {
      list[i].name = NULL;
      list[i].alive = false;
  }

  char fname[] = "arya_list.txt";

  FILE *fp;
  if (!(fp = fopen(fname, "r")))
  {
      printf("%s: No such file or directory\n\n", fname);
      return -1;
  }

  read_list(fp, list);
  
  fclose(fp);

  kill_by_name(list, "Cersei");

  fp = fopen(fname, "w");
  if (fp)
  {
      fprint_list(fp, list);
  }
  fclose(fp);

  print_list(list);

  return 0;
}