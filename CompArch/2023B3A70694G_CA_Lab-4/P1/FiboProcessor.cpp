#include <stdio.h>
#include <cstdint>

//Opcode of MIPS's instructions
#define R_OP 0
#define ADD_Func 32	
#define ADDI_OP 0b0001000// 8
#define LW_OP 35
#define SW_OP 43
#define BNE_OP 5
#define STP_OP 63 //Not a MIPS instruction 

uint32_t PC; //Program counter

int32_t JAddr;
uint8_t Shamt; // for shifting
uint8_t Funct, ALUOP;
uint8_t RS, RT, RD;
int16_t Immediate;

bool ZeroFlag; //

int32_t RegFile[32];

uint8_t Imem[256], Dmem[256]; //2^8 locations, byte addressable Instruction and Data memory

uint8_t  run = 1; //

void readRegfile(uint8_t in_reg_1,  uint8_t in_reg_2, int32_t *out_reg_1, int32_t *out_reg_2) {
	//First Register
	*out_reg_1 = RegFile[in_reg_1];
	//Second Register
	*out_reg_2 = RegFile[in_reg_2];
}
void writeRegfile(uint8_t in_reg, bool RegWrite, int32_t *out_reg) {
	if (RegWrite==true){
		if (in_reg == 0 )
	    	printf("Don't try to modify R0\n");
		else
			RegFile[in_reg] = *out_reg;}
	
}
int ALU(int in1, int in2) {
	int result;
	switch (ALUOP) {
		//used for LW, SW, ADDI 
		case 0:		
			result = in1 + in2;
			break;
		//used for BNE //
		case 1: 
			result = in1 - in2;
			break;
		//for rest of the instruction types
		case 2:
			switch(Funct) {
				case ADD_Func:  
					result = in1 + in2;
					break;					
			}
			break;
	}
	
	if (result == 0)
		ZeroFlag = true;
	else
	    ZeroFlag = false;
	return result;
}
uint32_t readIMM(uint32_t addr) {
	//Big-endian format - lower byte - higher address
	uint8_t byte0, byte1, byte2, byte3;
	uint32_t instr;
	
	byte3 = Imem[addr+0];		
	byte2 = Imem[addr+1];
	byte1 = Imem[addr+2];
	byte0 = Imem[addr+3];	
	
	instr = (byte3 << 24) + (byte2 << 16) + (byte1 << 8) + byte0;
	
	return instr;
}
int readDMM(int addr, bool MemRead) {
	//Big-endian format  - lower byte - higher address
	uint8_t byte0, byte1, byte2, byte3;
	int data;
	if (MemRead) {		
		
		byte3 = Dmem[addr+0];
		byte2 = Dmem[addr+1];
		byte1 = Dmem[addr+2];
		byte0 = Dmem[addr+3];		
		data = (byte3 << 24) + (byte2 << 16) + (byte1 << 8) + byte0;	
	}
	else
		printf("Error from Data memory's read module\n");
	return data;
}
void writeDMM(uint32_t addr, int data, bool MemWrite) {
	//Big-endian format  - lower byte - higher address
	uint8_t byte0, byte1, byte2, byte3;
	
	if (MemWrite) {
		
		byte3 = data >> 24;
		byte2 = (data & 0b00000000111111110000000000000000) >> 16;
		byte1 = (data & 0b00000000000000001111111100000000) >> 8;
		byte0 = (data & 0b00000000000000000000000011111111);
		
		Dmem[addr+0] = byte3;
		Dmem[addr+1] = byte2;
		Dmem[addr+2] = byte1;
		Dmem[addr+3] = byte0;	
		
	}
	else
		printf("Error from Data memory's write module\n");
		
}
uint32_t incrementPC(uint32_t pc){
	return pc + 4;
}
int32_t addBranchAddr(int32_t pc, int32_t branchAddr){
	return pc + branchAddr;
}
int32_t signExtn(int16_t offset) {
	int32_t temp;
	temp = offset;
	return temp;	
}
uint32_t leftShift2_16(int16_t offset) {
	int32_t temp;
	temp = offset;
	temp = temp << 2;
	return temp;
}
uint32_t leftShift2_25(int32_t offset) {
	int32_t temp;
	temp = offset << 2;
	return temp;
}
uint8_t fetchDecodeFSM(void) {
	uint8_t Opcode; // Other Global variable can be used.
	//Write your code here, without declaring extra variables
    Opcode = (readIMM(PC) >> 26); //opcode is the top 6 bits of the instruction, so a a right shift of 26 bits is done to get the opcode in the lower 6 bits of the instruction.
    RS = (readIMM(PC) >> 21) & 31; //shift and mask to get only the lower 5 bits of the instruction which is the RS field, specifies the register index
    RT = (readIMM(PC) >> 16) & 31;
    RD = (readIMM(PC) >> 11) & 31;
    Shamt = (readIMM(PC) >> 6) & 31;
    Funct = readIMM(PC) & 63;
    Immediate = (int16_t)(readIMM(PC) & 65535); 
    JAddr = readIMM(PC) & 0x03FFFFFF; //we use 0x03FFFFFF to mask the lower 26 bits so that JAddr only contains the address (lower 26 bits) and the opcode is discared (bit 31 to 26)
    PC = incrementPC(PC);
	return Opcode;
	
}
void lwFSM(void) {
	int32_t out_reg1, out_reg2, out_reg;
	//Write your code here, without declaring extra variables
	readRegfile(RS, RT, &out_reg1, &out_reg2);
    out_reg = ALU(out_reg1, signExtn(Immediate));
    out_reg2 = readDMM(out_reg, true);
    writeRegfile(RT, true, &out_reg2);
}

void swFSM(void) {
	int32_t out_reg1, out_reg2, out_reg;
	//Write your code here, without declaring extra variables
	readRegfile(RS, RT, &out_reg1, &out_reg2);
    out_reg1 = ALU(out_reg1, signExtn(Immediate));
    writeDMM((uint32_t)out_reg1, out_reg2, true);
}
void addFSM(void) {	
	int32_t out_reg1, out_reg2, out_reg;
	//Write your code here, without declaring extra variables
	readRegfile(RS, RT, &out_reg1, &out_reg2);
    out_reg = ALU(out_reg1, out_reg2);
    writeRegfile(RD, true, &out_reg);
}
void addiFSM(void) {
	int32_t out_reg1, out_reg2, out_reg;
	//Write your code here, without declaring extra variables
	readRegfile(RS, RT, &out_reg1, &out_reg2);
    out_reg = ALU(out_reg1, signExtn(Immediate));
    writeRegfile(RT, true, &out_reg);
}
void bneFSM(void) {	
	int32_t out_reg1, out_reg2, out_reg;
	//Write your code here, without declaring extra variables
	readRegfile(RS, RT, &out_reg1, &out_reg2);
    out_reg = ALU(out_reg1, out_reg2);
    if (!ZeroFlag) {
        Immediate = leftShift2_16(Immediate);
        PC = (uint32_t)addBranchAddr((int32_t)PC, Immediate);
    }
}

void stpFSM(void) {
	run=0;
}

void load_program(void);

int main(void) {
	RegFile[0] = 0;
	load_program();
	PC = 0;
	while (run) {
		uint8_t opcode = fetchDecodeFSM();
		switch (opcode) {
			case R_OP:  
			    ALUOP = 2;
				switch (Funct) {
					case ADD_Func: 
						addFSM();
						break;				
				}	
				break;
			case ADDI_OP: 
				ALUOP = 0; 
				addiFSM(); 
				break;
			case LW_OP:   
				ALUOP = 0; 
				lwFSM(); 
				break;
			case SW_OP:   
				ALUOP = 0; 
				swFSM(); 
				break;			
			case BNE_OP:  
				ALUOP = 1; 
				bneFSM(); 
				break;
			case STP_OP: 
				stpFSM(); 
				break;		
		}
	}
	printf("The Fibonacci numbers are:\n");
	for (int i = 0; i < 7; i++) {
		uint8_t byte0, byte1, byte2, byte3;
		int data;
		data = readDMM(252-(4*i), true);
		printf("%d, ", data);
	}
	printf("\n");
}

void load_program(void) {
	//Big-endian format lower-order addresses are used for the most significant byte
	Dmem[255] = 0b00000001;
	Dmem[254] = 0b00000000;
	Dmem[253] = 0b00000000;
	Dmem[252] = 0b00000000;

	Dmem[251] = 0b00000001;
	Dmem[250] = 0b00000000;
	Dmem[249] = 0b00000000;
	Dmem[248] = 0b00000000;	
	
	//Instructions
	
	// Code for generating the first 7 Fibonacci numbers.

	//ADDI R1, R0, 252 - ---- R1 <- R0 + 252
	Imem[0] = 0b00100000; 
	Imem[1] = 0b00000001;
	Imem[2] = 0b00000000;
	Imem[3] = 0b11111100;
	//ADDI R2, R0, 2 - ---- R2 <- R0 + 2 // counter
	Imem[4] = 0b00100000; 
	Imem[5] = 0b00000010;
	Imem[6] = 0b00000000;
	Imem[7] = 0b00000010;
	//ADDI R7, R0, 7 - ---- R7 <- R0 + 7 // Max val // doubt
	Imem[8] = 0b00100000;
	Imem[9] = 0b00000111;
	Imem[10] = 0b00000000;
	Imem[11] = 0b00000111;
	//LW R3, R1, 0 - ---- R3 <- Dmem[R1 + 0]
	Imem[12] = 0b10001100; 
	Imem[13] = 0b00100011;
	Imem[14] = 0b00000000;
	Imem[15] = 0b00000000; 
	//ADDI R1, R1, -4 - ---- R1 <- R1 - 4   //R1 - 248
	Imem[16] = 0b00100000; 
	Imem[17] = 0b00100001;
	Imem[18] = 0b11111111;
	Imem[19] = 0b11111100;
	//LW R4, R1, 0 - ---- R4 <- Dmem[R1 + 0]
	Imem[20] = 0b10001100; 
	Imem[21] = 0b00100100;
	Imem[22] = 0b00000000;
	Imem[23] = 0b00000000;
	//ADD R5, R3, R4 - ---- R5 <- R3 + R4
	Imem[24] = 0b00000000;
	Imem[25] = 0b01100100;
	Imem[26] = 0b00101000;
	Imem[27] = 0b00100000;
	//SW R5, R1, -4 - ---- Dmem[R1 - 4] <- R5 // 248-4 = 244
	Imem[28] = 0b10101100; 
	Imem[29] = 0b00100101;
	Imem[30] = 0b11111111;
	Imem[31] = 0b11111100;
	//ADDI R2, R2, 1 - ---- R2 <- R2 + 1   //Counter
	Imem[32] = 0b00100000; 
	Imem[33] = 0b01000010;
	Imem[34] = 0b00000000;
	Imem[35] = 0b00000001;
	//BNE R7, R2, -7(instructions)
	Imem[36] = 0b00010100; 
	Imem[37] = 0b01000111;
	Imem[38] = 0b11111111;
	Imem[39] = 0b11111001;
	 //STP
	Imem[40] = 0b11111100;
	Imem[41] = 0b00000000;
	Imem[42] = 0b00000000;
	Imem[43] = 0b00000000;	
}

