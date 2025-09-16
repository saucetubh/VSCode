#include<stdio.h>
#include<string.h>
#include<stdlib.h>

char* reverse(char* str) {
    int len = strlen(str);
    char* ans = malloc(len + 1);
    if(len > 1) {
        ans[0] = str[len-1];
        str[len-1] = '\0';
        strcpy(ans + 1, reverse(str));
    }
    else {
        ans[0] = str[0];
        ans[1] = '\0';
    }
    return ans;
}

int main() {
    char str[10] = "abcd";
    char* reversed = reverse(str);
    printf("%s\n", reversed);
    free(reversed); // Don't forget to free the memory!
    return 0;
}