#include <stdio.h>
#include <cstdint>
#include <iostream>
using namespace std;

bool out[3]; 

void printCounter(void) {
    cout << out[2] << out[1] << out[0] << endl;
}

int main(void) {    
    
    bool D_0, D_1, D_2;
    bool up; 

    out[0] = false;
    out[1] = false;
    out[2] = false; 

    cout << "Enter mux select (0 for DOWN, 1 for UP): ";
    cin >> up;


    printCounter();
    int temp = 16;
    while(temp--) {
        if (up) {
            D_2 = (out[1] && !out[0]) || (out[2] && out[0]);
            D_1 = (out[1] && !out[0]) || (!out[2] && out[0]);
            D_0 = !(out[2] != out[1]); //xnor
        }
        else {
            D_2 = (!out[1] && !out[0]) || (out[2] && out[0]);
            D_1 = (out[1] && !out[0]) || (out[2] && out[0]);
            D_0 = (out[2] != out[1]); //xor
        }

        out[0] = D_0;
        out[1] = D_1;
        out[2] = D_2;

        printCounter();
        
    }
    return 0;
}

//this program is basically a gray counter that counts up or down based on the user's input
//the count goes on indefinitely until interrupted by the user