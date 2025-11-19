#include <stdio.h> 
int main() {
int limit;
printf("Enter the limit: ");
scanf("%d", &limit);
for (int i=1; i<=limit; i++) {
	if (i%3 == 0 && i%5 == 0) {
		printf("Fizzbuzz\n");
	}
	else if (i%3 == 0) {
		printf("Fizz\n");
	}
	else if (i%5 == 0) {
		printf("Buzz\n");
	}
	else {
		printf("%d\n", i);
	}
}
return 0;
}
//this is a comment
