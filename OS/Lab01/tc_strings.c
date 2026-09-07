#include <string.h>

void tc_reverse(char *s) {
    size_t i = 0, j = strlen(s);
    while (i + 1 < j) {
        char tmp = s[i];
        s[i] = s[j - 1];
        s[j - 1] = tmp;
        i++;
        j--;
    }
}

size_t tc_count_char(const char *s, char c) {
    size_t count = 0;
    for (; *s != '\0'; s++)
        if (*s == c) count++;
    return count;
}
