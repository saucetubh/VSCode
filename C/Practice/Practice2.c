#include<stdio.h> 

int main()  {
    double radius = 5;
    const double PI = 3.14;
    double area = PI * radius * radius;
    printf("Radius is %.1lf and area is %.2lf\n", radius, area);
    return 0;
}
