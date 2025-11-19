#include <stdio.h>
#include<stdlib.h>
int floordiv(int a, int b) {
int result = a/b;
return result;
}
int main(int argc, char *argv[]) {
int a = atoi(argv[1]);
int b = atoi(argv[2]);
printf("%d", floordiv(a,b));
}
