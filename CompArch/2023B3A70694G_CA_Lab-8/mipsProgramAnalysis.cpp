/*########################################################
Note: Please don’t upload the assignments, template file/solution and lab.
manual on GitHub or others public repository. Kindly remove them, if you have
uploaded the previous assignments. It violates the BITS’s Intellectual Property
Rights (IPR).
********************************************************/
#include <algorithm>
#include <cstring>
#include <fstream>
#include <iostream>
#include <string>

int flag = 0;
std::string Instructions[1000];               // Only instructions are paresed in this array. No
                                              // comments!!
std::string DependentInstructionSet[2000][2]; // Dependeny Instructions 2D array
std::string code[1000];                       // instruction + Labels
std::string BW_Labels[1000];
std::string FW_Labels[1000];

int windex = 0;
int FwdJump = 0, BackJump = 0;
int Labels[1000]; // Label flag bit 0 means it's an instruction, 1 means it is
                  // a label
int insCount = 0;
int VALIDINSTR = 0;
int dCount = 0; // total number of dependencies found
std::string instructionset[86] = {
    "add",   "addi", "addiu", "addu",  "clo",  "clz",   "la",   "li",     "lui",  "move", "negu",  "seb",    "seh",
    "sub",   "subu", "rotr",  "rotrv", "sll",  "sllv",  "sra",  "srav",   "srl",  "srlv", "and",   "andi",   "ext",
    "ins",   "nop",  "nor",   "not",   "or",   "ori",   "wsbh", "xor",    "xori", "movn", "movz",  "stl",    "stli",
    "stliu", "stlu", "div",   "divu",  "madd", "maddu", "msub", "msubu",  "mul",  "mult", "multu", "mfhi",   "mflo",
    "mthi",  "mtlo", "b",     "bal",   "beq",  "beqz",  "bgez", "bgezal", "bgtz", "blez", "bltz",  "bltzal", "bne",
    "bnez",  "j",    "jal",   "jalr",  "jr",   "lb",    "lbu",  "lh",     "lhu",  "lw",   "lwl",   "lwr",    "sb",
    "sh",    "sw",   "swl",   "swr",   "ulw",  "usw",   "ll",   "sc"};
// 41-49 mul/divide
// 50-53 accumulator access op
// 54-69 jump and branch
// 70-83 load and store
// 84-85 atomic read modify write
int TYPE[9] = {0};
int TYPERJI[1000];

std::string instructionsetRJI[48] = {"sll",  "sllv", "sra",  "srav",  "srl",  "srlv",  "jalr", "jr",   "mfhi", "mflo",
                                     "mthi", "mtlo", "mult", "multu", "div",  "divu",  "add",  "addu", "sub",  "subu",
                                     "and",  "or",   "xor",  "nor",   "stlu", "slt",   "j",    "jal",  "beq",  "bne",
                                     "blez", "bgtz", "addi", "addiu", "slti", "sltiu", "andi", "ori",  "xori", "lui",
                                     "lb",   "lh",   "lw",   "lbu",   "lhu",  "sb",    "sh",   "sw"};

std::string registerSet[32] = {"zero", "at", "v0", "v1", "a0", "a1", "a2", "a3", "t0", "t1", "t2",
                               "t3",   "t4", "t5", "t6", "t7", "t8", "t9", "s0", "s1", "s2", "s3",
                               "s4",   "s5", "s6", "s7", "k0", "k1", "gp", "sp", "fp", "ra"};

int countOfReg[32] = {0};

void countRegister(); // to count number of register
void printNoReg();    // to print numner of register

int checkTypeRJI(int i); // return int and checks the type of instruction

std::string printType(int i);
void printInstrType(); // function prints all valid instruction

void verifyInstr_setType(std::string str);
int checkLine(std::string line, std::string *validLine);

void checkDependency();

void printCode();
void countLabels(int, std::string);
void printJumpLabels();
void printDependentInstr();

int main(int arg, char *str[]) {
    int tnoi = 0;   // total number of instructions
    int typeoi = 0; // types of instructions

    int nloops = 0; // number of loops
    int typeofloop;

    std::ifstream fin;  // for input file
    std::ofstream fout; // output file stream
    std::cout << "File Name: \t\t" << str[1] << std::endl;
    fin.open(str[1]);
    std::string line, validLine;
    int count = 0;

    while (fin) { // execute a loop until EOF
        getline(fin, line);
        if (checkLine(line, &validLine) != 0) {
            code[windex] = validLine;
            Labels[windex] = 1;

            verifyInstr_setType(validLine);
            windex++;

            count++;
        }
    }

    printInstrType();
    std::cout << "---------------------------------------------------------------" << std::endl;
    std::cout << "Total Lines w/o Comments   =  " << count << std::endl;
    std::cout << "Total Valid Instructions   =  " << insCount << std::endl;
    std::cout << "Backward Loops/JUMP        =  " << BackJump << std::endl;
    std::cout << "Forward LOOPS/JUMP         =  " << FwdJump << std::endl;

    std::cout << "---------------------------------------------------------------" << std::endl;
    printJumpLabels();
    countRegister(); // WRITE YOUR CODE FOR this function
    printNoReg();
    checkDependency(); // WRITE YOUR CODE this function
    if (dCount == 0) {
        std::cout << " No Dependent Instruction !!" << std::endl;
    }
    else {
        printDependentInstr(); // prints the dependent instructions
    }

    return 0;
}

std::string trim(const std::string &str) {
    size_t first = str.find_first_not_of(" \t\n\r\f\v"); // Find first non-whitespace character
    if (first == std::string::npos) {
        return ""; // All characters are whitespace
    }

    size_t last = str.find_last_not_of(" \t\n\r\f\v"); // Find last non-whitespace character
    return str.substr(first, last - first + 1);
}

int checkLine(std::string line, std::string *validLine) {
    std::string st = trim(line); // Remove leading and trailing spaces
    if (st.length() == 0) {
        return 0;
    }
    std::string opcode, f1, f2, f3;
    std::string instr;
    int i, start = 0;
    bool first = true;

    for (i = 0; i < line.length();) {
        if ((line[i] == ' ' || line[i] == '\t') && first == true) {
            start++;
            i++;
        }
        else {
            first = false;
            if (line[i] == '#') {
                break; // comment
            }
            i++;
        }
    }
    *validLine = line.substr(start, i - 1);
    return validLine->length();
}

void verifyInstr_setType(std::string instr) // whole line
{
    // Count the jump labels from here and use the function countLabel()
    // WRITE YOUR CODE HERE
    char *instruc;
    std::string opcode;
    VALIDINSTR++;

    std::string currentOpcode = instr.substr(0, instr.find(' '));
    bool instructionWasValid = false;
    int i = 0;

    while (i < 86 && !instructionWasValid) {
        if (instructionset[i] == currentOpcode) {
            Instructions[insCount] = instr;
            insCount++;
            instructionWasValid = true;

            int k = 0;
            while (k < 48) {
                if (currentOpcode == instructionsetRJI[k]) {
                    break;
                }
                k++;
            }

            TYPERJI[insCount - 1] = checkTypeRJI(k);
            if (TYPERJI[insCount - 1] == 1) {
                countLabels(k, instr);
            }
        }
        i++;
    }

    if (!instructionWasValid) {
        VALIDINSTR--;
    }
}

void printJumpLabels() {
    int total;
    int bw_index = 0;
    int fw_index = 0;
    total = std::max(BackJump, FwdJump);
    std::cout << "\n---------------------------------------------------------------" << std::endl;
    std::cout << "BACKWARD LABEL\t\t\tFORWARD LABEL" << std::endl;
    for (int i = 0; i < total; i++) {
        if (BackJump > i) {
            // std::cout << 1;
            std::cout << BW_Labels[bw_index] << "\t\t\t";
            bw_index++;
        }
        else {
            // std::cout << 2;
            std::cout << "-------\t\t\t";
        }
        if (FwdJump > i) {
            // std::cout << 3;
            std::cout << FW_Labels[fw_index] << std::endl;
            fw_index++;
        }
        else {
            // std::cout << 4;
            std::cout << "\t-------\n";
        }
    }
    std::cout << "---------------------------------------------------------------";
}
void printInstrType() {
    std::cout << "-----------------TOTAL INSTRUCTIONS----------------------------" << std::endl;
    for (int i = 0; i < insCount; i++) {
        std::cout << Instructions[i] << "\t" << printType(i) << std::endl;
    }
}

std::string printType(int i) {
    if (TYPERJI[i] == 0) {
        return "\t\t    ------ R Type ";
    }
    if (TYPERJI[i] == 1) {
        return "\t\t    ------ J Type ";
    }
    if (TYPERJI[i] == 2) {
        return "\t\t    ------ I Type ";
    }
    return "\t\t    ------ Others ";
}

int checkTypeRJI(int i) {
    if (i <= 25) {
        return 0; // type R
    }
    else if (i == 26 || i == 27) {
        return 1; // type J
    }
    else if (i < 48 && i >= 28) {
        return 2; // type immediate
    }
    else return -1;
}

void printCode() {
    for (int i = 0; i < windex; i++) {
        std::cout << code[i];
        if (Labels[i] == 1) {
            std::cout << "\t\t\t\t-- Label";
        }
        std::cout << std::endl;
    }
}

void countLabels(int i, std::string str) {
    // WRITE YOUR CODE HERE
    if (i == 26) {
        BW_Labels[BackJump] = str.substr(instructionsetRJI[i].size());
        BackJump++;
    }
    if (i == 27) {
        FW_Labels[FwdJump] = str.substr(instructionsetRJI[i].size());
        FwdJump++;
    }
}
void printDependentInstr() {
    int total_dependencies;
    total_dependencies = dCount;

    std::cout << "\n--------------------DEPENDENT INSTRUCTIONS---------------------" << std::endl;
    for (int i = 0; i < total_dependencies; i++) {
        std::cout << DependentInstructionSet[i][0] << "\t\t\t---> " << DependentInstructionSet[i][1] << std::endl;
    }
    std::cout << "---------------------------------------------------------------" << std::endl;
}

void countRegister() {
    // WRITE YOUR CODE HERE
    int j = 0;
    while (j < 32) {
        int i = 0;
        while (i < insCount) {
            if (Instructions[i].find(registerSet[j]) != std::string::npos &&
                Instructions[i].find("($" + registerSet[j] + ')') == std::string::npos &&
                Instructions[i].find("$" + registerSet[j]) != std::string::npos) {
                countOfReg[j]++;
            }
            i++;
        }
        j++;
    }
}

void printNoReg() {
    int count = 0;
    std::cout << "\n\n---------------------------------------------------------------" << std::endl;
    std::cout << "Names of Register used     =  ";
    for (int i = 0; i < 32; i++) {
        if (countOfReg[i] > 0) {
            count++;
            std::cout << registerSet[i] << " ";
        }
    }
    std::cout << "\nTotal number of registers  =  " << count << std::endl;
    std::cout << "---------------------------------------------------------------" << std::endl;
}

void checkDependency() {
    /*NOTE Dependency for others-type instructions have not been evaluated*/
    // WRITE YOUR CODE HERE
    int i = 0;
    while (i < insCount) {     // Go over all instructions
        if (TYPERJI[i] == 1) { // J Type
            i++;
            continue;
        }

        int start = 0;
        for (; Instructions[i][start] != ' '; start++) {
        }
        start++;
        start++;
        std::string writeReg = Instructions[i].substr(start, 2);
        int j = i + 1;
        while (j < insCount) {
            int in = 0;
            bool dependencyFound = false;

            while (in < Instructions[j].size() && Instructions[j][in] != ',') {
                in++;
            }
            while (in < Instructions[j].size() && Instructions[j][in] != '$') {
                in++;
            }
            in++;

            if (in < Instructions[j].size() - 1 && Instructions[j].substr(in, 2) == writeReg) { // Dependency Found
                DependentInstructionSet[dCount][0] = Instructions[i];
                DependentInstructionSet[dCount][1] = Instructions[j];
                dCount++;
                dependencyFound = true;
            }

            if (!dependencyFound) {
                while (in < Instructions[j].size() && Instructions[j][in] != '$') {
                    in++;
                }
                in++;
                if (in < Instructions[j].size() - 1 && Instructions[j].substr(in, 2) == writeReg) { // Dependency Found
                    DependentInstructionSet[dCount][0] = Instructions[i];
                    DependentInstructionSet[dCount][1] = Instructions[j];
                    dCount++;
                }
            }
            j++;
        }
        i++;
    }

    std::cout << "\n\n---------------------------------------------------------------" << std::endl;
    std::cout << "Total RAW Dependency       =  " << dCount << std::endl;
    std::cout << "---------------------------------------------------------------" << std::endl;
}