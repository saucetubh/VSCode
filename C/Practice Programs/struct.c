#include<stdio.h>
#include<string.h>

struct information{
    int age;
    double number;
    char gender;
    char name[50];
};

struct team{
    int zipcode;
    char city[50];
    char country[50];
    struct information player[3];
};

int main() {
    struct team teams[2];
    for (int i = 0; i < 2; i++) {
        printf("Enter the zipcode of the team: ");
        scanf("%d", &teams[i].zipcode);
        printf("Enter the city of the team: ");
        scanf("%s", teams[i].city);
        printf("Enter the country of the team: ");
        scanf("%s", teams[i].country);
        for (int j = 0; j < 3; j++) {
            printf("Enter the name of the player: ");
            scanf("%s", teams[i].player[j].name);
            printf("Enter the age of the player: ");
            scanf("%d", &teams[i].player[j].age);
            printf("Enter the phone number of the player: ");
            scanf("%lf", &teams[i].player[j].number);
            printf("Enter the gender of the player: ");
            scanf(" %c", &teams[i].player[j].gender);
        }
    }
    struct team team3 = {12345, "New York", "USA", {{25, 1234567890, 'M', "John"}, {30, 1234567890, 'F', "Doe"}, {35, 1234567890, 'M', "Smith"}}};
    
    for (int i = 0; i < 2; i++) {
        printf("Team %d\n", i + 1);
        printf("Zipcode: %d\n", teams[i].zipcode);
        printf("City: %s\n", teams[i].city);
        printf("Country: %s\n", teams[i].country);
        for (int j = 0; j < 3; j++) {
            printf("Player %d\n", j + 1);
            printf("Name: %s\n", teams[i].player[j].name);
            printf("Age: %d\n", teams[i].player[j].age);
            printf("Phone number: %.0lf\n", teams[i].player[j].number);
        }
    }
}