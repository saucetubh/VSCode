//Have the correct header files. Enter as many you want.
#include<stdio.h>
#include<string.h>
/*
Displays all the information of the employee.
*/

typedef struct Employee{
  int id;
  int salary;
  char fav_quote[50];
  int sick_leaves[6];
}emp;

void display(emp e)
{
  printf("Employee ID: %d\n", e.id);
  printf("Salary: %d\n", e.salary);
  printf("Favorite Quote: %s\n", e.fav_quote);
  for(int j = 0; j < 6; j++)
    printf("Sick Leaves for Month %d: %d\n", j + 1, e.sick_leaves[j]);
}

/**
 * @brief Returns the employee with the highest salary.
 * If both have the same salary, return the employee with the higher employee id
 * 
 * Requires: Each employee has a unique employee id
 * 
 * Example 1: 
 *    e1 = {1, 10000, "BITS_Pilani.", {1,2,3,1,2,1}};
 *    e2 = {2, 20000, "Is_Magic.", {1,1,2,2,3,3}};
 *    Returns e2
 * 
 * Example 2:
 *    e1 = {1, 10000, "BITS_Pilani.", {1,2,3,1,2,1}};
 *    e2 = {2, 10000, "Is_Magic.", {1,1,2,2,3,3}};
 *    Returns e2
*/
//TODO: Complete the function header - add arguments to match the call from main()
emp max_salary(emp *e1, emp *e2) 
{
  if(e1->salary > e2->salary) {
    return *e1;
  }
  else if(e2->salary > e1->salary) {
    return *e2;
  }
  else {
    if (e1->id > e2->id) {
      return *e1;
    }
    else {
      return *e2;
    }
  }
}

/**
 * @brief Prints the longest word in the favourite quote of the employee with the higher salary.
 * If there are more than 1 word having the same longest length, then print the word that starts at the higher index.
 * 
 * Requires: The quote will have '_' (underscore) as word separators and '.' (period/full stop) as the end of the quote.
 * Assume that words are non empty. That is, quote will not be "_."
 * Words contain only alphabets and digits.
 *
 * Example 1:
 *    s= "BITS_Pilani."
 *    Prints: The longest word is: Pilani
 * 
 * Example 2:
 *    s= "Its_Magic."
 *    Prints: The longest word is: Magic
 * 
 * Example 3:
 *    s= "Life_is_good."
 *    Prints: The longest word is: good
*/
void longest_word(char* s)
{
  char longest[50] = "\0"; 
  while (*s != '.') {
    char word[50];
    int i=0;
    while (*s != '_' && *s != '.') {
      word[i] = *s;
      i++;
      s++;
    }
    word[i] = '\0';
    if (strlen(word) >= strlen(longest)) {
      strcpy(longest, word);
    }
    if (*s != '.') {
      s++;
    }
  }
  printf("The longest word is: %s\n", longest);
}

/**
 * @brief Save in the output parameter 'mode' the mode of the sick leaves array for the employee. 
 * In output parameter 'avg', save the average number of sick leaves taken in 6 months.
 * 
 * The mode will save the the sick leaves that appears most in the period of 6 months.
 * If there are multiple modes, select the one whose first occurence starts the latest.
 * 
 * The average will be printed by ".1lf" format specifier in main().
 * 
 * Example 1:
 *    arr[] = {1,2,3,1,2,1}
 *    mode = 1
 *    avg = 1.7
 * 
 * Example 2:
 *    arr[] = {1,1,2,2,3,3}
 *    mode = 3
 *    avg = 2.0
*/
//TODO: Complete the function header - have appropriate arguments to match the function call in main()
void cal_sick_leaves(int *l, int n, int *mode, double *avg)
{
  int freq[32] = {0};
  for(int i=0; i<n; i++) {
    freq[l[i]]++;
  }
  int max=0;
  for(int i=0; i<32; i++) {
    if(freq[i]>=max) {
      max = freq[i];
      *mode = i;
    }
  }
  int sum=0;
  for(int i=0; i<n; i++) {
    sum+=l[i];
  }
  *avg = (double)sum/n;
}

/**
 * @brief Prints the character that occurs the minimum number of times in the favourite quote of the employee with the higher salary.
 * If there are more than 1 characters occuring the least, then print the character that has its first occurence at the higher index.
 * Do NOT ignore the case of the character. Period/full stop(.) should NOT be considered for this calculation.
 * 
 * Requires: The quote will have '_' (underscore) as word separators and '.' (period/full stop) as the end of the quote.
 * Assume that words are non empty. That is, quote will not be "_."
 * Words contain only alphabets and digits.
 *
 * Example 1:
 *    s= "BITS_Pilani."
 *    Prints: The character occuring the minimum time is: n
 * 
 * Example 2:
 *    s= "Its_Magic."
 *    Prints: The character occuring the minimum time is: c
 * 
 * Example 3:
 *    s= "Life_is_good."
 *    Prints: The character occuring the minimum time is: d
*/
void min_occurence(char* s)
{
  char c;
  int freq[123] = {0};
  int i=0;
  while(s[i] != '.') {
    freq[s[i]]++;
    i++;
  }
  int min=51;
  for(int i=0; i<123; i++) {
    if(freq[i]<=min) {
      min=freq[i];
      c=(char)i;
    }
  }
  printf("The character occuring the minimum time is: %c\n", c);
}

/**
 * @brief Populates the employee details and returns the employee.
*/
emp get_input()
{
  emp e;
  printf("Enter employee id:\n");
  scanf("%d", &e.id);
  printf("Enter employee's salary:\n");
  scanf("%d", &e.salary);
  printf("Enter Favorite Quote (each word is separated by '_' and the phrase ends with a '.'):\n");
  scanf("%s", e.fav_quote);
  printf("Enter sick leaves taken by an employee for each month during the first 6 months\n");
  for(int i = 0; i < 6; i++)
    scanf("%d", &e.sick_leaves[i]);

  return e;
}

int main()
{
  emp e1 = get_input();
  emp e2 = get_input();

/* 
  //UNCOMMENT this block if you want to test your code quickly with different values.
  //Keep in mind to COMMENT this block once you are done with testing else test cases WILL NOT PASS.
  //Sample inputs are given. Change it to test different cases.
  //Note: If you are hardcoding values for testing, you need to comment out the get_input statements for e1 and e2
  emp e1 = {1, 10000, "BITS_Pilani.", {1,2,3,1,2,1}};
  emp e2 = {2, 20000, "Its_Magic.", {3,2,2,3,1,4}};
  
  display(e1);
  display(e2);
*/
  
  emp max = max_salary(&e1, &e2);

  printf("ID of the employee with the highest salary is: %d\n", max.id);

  printf("This program supports THREE operations for the employee with the highest salary:\n");
  printf("\t1. Find the longest word in the employee's favorite quote,\n");
  printf("\t2. Find the number of sick leaves that appears the most (i.e. mode) and the average number of sick leaves taken.\n");
  printf("\t3. Find the character in the quote that occurs the minimum number of times.\n\n");
  printf("Choose an operation (1 or 2 or 3): ");
  int operation = 0;
  scanf("%d", &operation);

  if(operation == 1)
  {
    longest_word(&max.fav_quote[0]);
  }

  else if(operation == 2)
  {
    int mode;
    double avg;
    cal_sick_leaves(&max.sick_leaves[0], 6, &mode, &avg);
    printf("The number of sick leaves appearing the most: %d\n", mode);
    printf("The average number of sick leaves: %.1lf\n", avg);
  }

  else if(operation == 3)
  {
    min_occurence(&max.fav_quote[0]);
  }
  return 0;
}