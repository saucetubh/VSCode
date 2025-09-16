#include<stdio.h>
#include<string.h>

void swap(char *a, char *b){
char temp= *a; *a=*b; *b=temp;
}
void func(char str[], int start, int last) {
if(start==last){
for(int i=0;i<=last;i++){
printf ("%c", str[i]);
}
printf(",");
}
else{
for(int i=start;i<=last;i++){
swap (&str[start] , &str[i]) ;
func(str,start+1,last);
swap(&str[start], &str[i]);
}
}
}
int main(){

char str[4] = "abc";
func(str,0,strlen(str)-1);
return 0;
}