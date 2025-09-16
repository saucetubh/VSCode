/*
#include <stdio.h>
#include <stdlib.h>

int* f(int x, int *y, int **z)
{
    *z = malloc(sizeof(int));
    y = malloc(sizeof(int));
    **z = 5;
    **z += 6;
    x += 3;
    *y = 4;
    return y;
}

int main()
{
    int x = 5;
    int *y = &x;
    int **z = &y;
    *z = f(x, y, z);
    printf("%d, %d, %d", x, *y, **z);
    return 0;
}
*/

/*
#include <stdio.h>

int main()
{
    char b[3][4] = {"ABC", "DEF", "GHI"};
    printf("%p %c", *(b+2)+1, *(*(b+2)+1));
    return 0;
} //if starting address of b is 0x74, then the output will be 0x7D H, not 0x7B H because the strings also end in the /0 character which occupies one byte
*/
/*
#include <stdio.h>
#include <string.h>
void rev_str ( char *s , char * ans )
{
int n = strlen ( s ) ;
for ( int i = 0; i < (n/2)+1 ; ++ i )
{
ans [ i ] = s [ n - i - 1];
ans [ n - i - 1] = s [ i ];
}
ans [ n ] = '\0';
}

int main() {
    char s[] = "ab";
    char ans[6];
    rev_str(s, ans);
    printf("%s", ans);
    return 0;
}
*/
/*
#include <stdio.h>

int main() {
    int a[] = {100, 200, 300, 400};
    int* p = &a[1];
    *p++; //higher precedence here means that ++ binds itself to p, not to *p. However due to nature of postfix increment, the value of p is incremented after the statement is executed i.e after it is incremented.
    printf("%d\n", a[1]);
    printf("%d\n", *p);
    printf("%d\n", --*p);
    printf("%d\n", *p);
    printf("%d\n", a[2]);
    printf("%d\n", ++*p);
    printf("%d\n", *p--);
    printf("%d\n", *p++);
    printf("%d\n", *p);
    printf("%d\n", *++p);
}
*/

/*
#include<stdio.h>

int main() {
    int a=10, b=20, c=50;
    if((a=100) && (c=0) && (b=200)) {  //lazy orring  and short circuit evaluation, where the last part is not executed if enough conditions are satisfied already
        b*=100;
    }
    else {
        b+=300;
    }
    printf("a = %d, b = %d, c = %d\n", a, b, c);
}
//in case of or if atleast one condition true, it wont evaluate further
//in case of and if atleast one condition false, it wont evaluate further
*/

/*
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

char* reverse(char* str) {
    int len = strlen(str);
    char* ans = (char *) malloc(len+1);
    if(len > 1) {
        ans[0] = str[len-1];
        str[len-1] = '\0';
        strcat(ans, reverse(str));
    }
    else {
        ans[0] = str[0];
        ans[1] = '\0';
    }
    return ans;
}

int main() {
    char str[] = "abcd";
    char *reversed = reverse(str);
    printf("%s", reversed);
}
*/
/*
#include<stdio.h>

int main() {
    int x = -20;
    int y = -8;
    printf("%d", x%y);
}
*/