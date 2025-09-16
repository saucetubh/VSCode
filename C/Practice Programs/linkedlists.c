#include<stdio.h>
#include<stdlib.h>

typedef struct Record{
    int id;
    record* next;
}record;

int main() {
    record* tablestart = (record *)malloc(sizeof(record));
    
}
