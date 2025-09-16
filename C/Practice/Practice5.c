#include<stdio.h>

double sum(double x, double y);         //declaration of function so that memory allocation begins

int main(){
    int x, y;
    printf("Enter two integers: ");
    scanf("%d %d", &x, &y);
    printf("Sum is %.2lf\n", sum(x,y));   //calling the function 
    return 0;
}

double sum(double x, double y) { 
    return(x+y);
}
