#include<stdio.h>
#include<math.h>
#include<string.h>
#include<stdbool.h>
/*
 int main() {
    char grade = 'E';
    switch(grade) {
        case 'B':
            printf("Good!\n");
        default:
            printf("Invalid grade!\n");
        case 'C':
            printf("Average!\n");
            break;
        case 'A':
            printf("Excellent!\n");
        case 'D':
            printf("Needs Improvement!\n");
    }
    int num = 4;
    switch (num) {
        case 1: printf("One\n"); break;
        case 2: printf("Two\n"); break;
        case 3: printf("Three\n"); 
        default: printf("Default\n");
    }
}
*/
/*
int main() {
    int day;
    printf("Enter day (1-7): ");
    scanf("%d", &day);
    printf("Day is ");
    switch (day) 
    {
        default:
        printf("Incorrect day entered\n");    
        case 1:
            printf("Monday\n");
            break;
        case 2:
            printf("Tuesday\n");
            break;
        case 3:
            printf("Wednesday\n");
        case 4:
            printf("Thursday\n");
            break;
        case 5:
            printf("Friday\n");
        case 6:
            printf("Saturday\n");
            break;
        case 7:
            printf("Sunday\n");
            break;
    }
}
*/

int main() {
    int outer = 2;
    int inner = 3;

    switch (outer) {
        case 2:
            printf("Outer 2\n");
            //no break so it falls through and also checks the inner switch
        case 1:
            printf("Outer 1\n");
            switch (inner) {
                default:
                    printf("Inner default\n");
                    break;
                case 1:
                    printf("Inner 1\n");
                    // No break here, so it falls through to the next case in the inner switch
                case 2:
                    printf("Inner 2\n");
                    break;
            }
    }

    return 0;
}


/*/
int main() {
    int a = 35;
    int b = 20;
    int min = (a<b)? a : b;
    printf("Smaller number is %d\n", min);
    int score = 85;
    printf("You have %s\n", (score>=50)? "passed" : "failed");
}
/*/
