/*########################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository.
Kindly remove them, if you have uploaded the previous assignments.
It violates the BITS’s Intellectual Property Rights (IPR).
********************************************************/

#include <fstream>
#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

using namespace std;

// Parameters for BTB
#define N_ENTRY_BTB 2 // 0. BIA and 1. BTA
#define N_ROWS_BTB 8  // 2^n

#define N_BIT 2 // bit used in the predictors
// branch's actual outcome stored into the file.
char BOUTCOME_FILE[100];

#define INIT_STATE 0 // initial state of the predictors

// Parameters for Two-level branch predictor
#define N_BITS_PC_2LEVEL 3
#define N_BITS_LBP 2
#define initStateLBP 0 // Starting state in the saturation BP

int **BTB = NULL; //[0] for BIA val and [1] for BTA
int BTBLastIndx = -1;

FILE *fp = NULL;

int getPrediction(int n, int currState) {
    int maxState, pivotState, prediction;
    // WRITE YOUR CODE HERE (from the Bi-modal)
    maxState = pow(2, n) - 1;
    pivotState = maxState / 2;
    if (currState <= pivotState) prediction = 0;
    else prediction = 1;

    return prediction;
}
void updateNbitPredictor(int n, int *currState, int actualOutcome) {
    // actualOutcome can have values either 0 (untaken) or 1 (taken)
    int maxState, pivotState;
    // WRITE YOUR CODE HERE (from the Bi-modal)
    maxState = pow(2, n) - 1;
    pivotState = maxState / 2;
    if (actualOutcome == 0) {
        if (*currState > 0) *currState = *currState - 1;
    }
    else {
        if (*currState < maxState) *currState = *currState + 1;
    }
}

void initBTB(void) {

    BTB = new int *[N_ROWS_BTB];
    for (int i = 0; i < N_ROWS_BTB; i++) {
        BTB[i] = new int[N_ENTRY_BTB];
        BTB[i][0] = 0;  // assigning the PC value as 0
        BTB[i][1] = -1; // assigning the BTA as -1
    }
}
int searchIndxBTB(int val) {
    int i;
    for (i = 0; i < N_ROWS_BTB; i++) {
        if (BTB[i][0] == val) {
            break;
        }
    }
    if (i == (N_ROWS_BTB)) {
        // if entry not found
        return -1;
    }
    else return i;
}

int getTableIndx(int val) {

    // WRITE YOUR CODE HERE (from the Bi-modal)
    return val % (int)pow(2, N_BITS_PC_2LEVEL);
}

//=================================================== 2-level Branch predictor========================================
int **LHT_2Level = NULL;

void initLHT2Level(void) {

    int noEntry = pow(2, N_BITS_PC_2LEVEL);
    int noInfo = 2; //[0] for histroy and [1] for BPs
    LHT_2Level = new int *[noEntry];
    for (int i = 0; i < noEntry; i++) {
        LHT_2Level[i] = new int[noInfo];
        LHT_2Level[i][0] = 0;            // assigning the history as 0s
        LHT_2Level[i][1] = initStateLBP; // assigning the initial value, initStateLBP, to each predictors.
    }
}
void updateLHT2Level(int indx, int outcome) {
    int temp;
    // WRITE YOUR CODE HERE

    temp = LHT_2Level[indx][0];

    if (outcome == 1) {
        LHT_2Level[indx][0] = (LHT_2Level[indx][0] >> 1) | (0b00000100);
    }
    else {
        LHT_2Level[indx][0] = (LHT_2Level[indx][0] >> 1) & (0b00000011);
    }

    updateNbitPredictor(N_BIT, &LHT_2Level[temp][1], outcome);
}

void twoLevelBranchPredictor() {

    char outcome[4];
    int pc, indxBTB, indxLHT, getCurState, intOutcome, predictOutcome;
    int **predictStat = NULL;

    // i-th predictor's prediction statistics: predictStat [i][0] for total decissions and
    // predictStat[i][1] for correct decissions

    predictStat = (int **)malloc(N_ROWS_BTB * sizeof(int *));
    for (int i = 0; i < N_ROWS_BTB; i++) {
        predictStat[i] = (int *)malloc(2 * sizeof(int));
        predictStat[i][0] = 0;
        predictStat[i][1] = 0;
    }
    fp = fopen(BOUTCOME_FILE, "r");

    // WRITE YOUR CODE HERE
    initBTB();
    initLHT2Level();

    while (fscanf(fp, "%x %s", &pc, outcome) != EOF) {
        indxBTB = searchIndxBTB(pc);
        if (indxBTB == -1) {
            // if entry not found
            indxBTB = (BTBLastIndx + 1) % N_ROWS_BTB;
            BTB[indxBTB][0] = pc;
            BTBLastIndx = indxBTB;
        }
        indxLHT = getTableIndx(pc);
        getCurState = LHT_2Level[LHT_2Level[indxLHT][0]][1];
        predictOutcome = getPrediction(N_BIT, getCurState);
        if (strcmp(outcome, "T") == 0) {
            intOutcome = 1;
        }
        else {
            intOutcome = 0;
        }
        if (predictOutcome == intOutcome) {
            predictStat[indxBTB][1]++;
        }
        predictStat[indxBTB][0]++;
        updateLHT2Level(indxLHT, intOutcome);
    }

    fclose(fp);
    cout << "############################################################################" << endl;
    cout << "2-level Branch Predictor's Statistics\n";
    for (int i = 0; i < (BTBLastIndx + 1); i++) {
        cout << "========================================================================" << endl;
        cout << i + 1 << " predictor's (" << BTB[i][0] << ") total prediction: " << predictStat[i][0] << endl;
        cout << i + 1 << " predictor's (" << BTB[i][0] << ") correct prediction: " << predictStat[i][1] << endl;
        cout << i + 1 << " predictor's (" << BTB[i][0] << ") accuracy: " << float(predictStat[i][1]) / predictStat[i][0]
             << endl;
    }
    cout << "##############################################################################" << endl;
    float avgAccuracy = 0;
    for (int i = 0; i < (BTBLastIndx + 1); i++) {
        avgAccuracy += float(predictStat[i][1]) / predictStat[i][0];
    }
    avgAccuracy = avgAccuracy / (BTBLastIndx + 1);
    cout << "2-level BP's Average accuracy= " << avgAccuracy << endl;
}

int main(int argc, char **argv) {
    strcpy(BOUTCOME_FILE, argv[1]);
    twoLevelBranchPredictor();
}
