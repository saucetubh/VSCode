/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
//MIPS's instruction's Opcode

`define ADDI    6'd8
`define LW      6'd35
`define SW      6'd43
`define BNE     6'd5
`define ADD     6'd0

module controlCircuit(input clk, input reset, input [5:0] opcode, input [5:0] funct, output reg pcWr, output reg  pcSrc,
                             output reg bne, output reg irWr, output reg memRead, output reg regWr, output reg regDest, 
                             output reg  memToReg, output reg aluSrcA, output reg [1:0] aluSrcB, output reg [1:0] aluOp, 
                             output reg zero, output reg memWr, output reg iorD);
	// Write your code here
	reg [3:0] state;
	reg [3:0] nextstate;
    parameter T0 = 0, T1 = 1, T2 = 2, T3 = 3, T4 = 4, T5 = 5, T6 = 6, T7 = 7, T8 = 8, T9 = 9;
	
	//WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
	always @(posedge clk, reset) begin
        case (reset)
            1'b0: state = nextstate;
            1'b1: state = T0;
        endcase
    end

    always @(opcode, state) begin
        case (state)
            T0: begin
                pcWr = 1'b1;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b1;
                memRead = 1'b1;
                regWr = 1'b0;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 2'b01;
                aluOp = 2'b00;
                zero = 1'b0;
                memWr = 1'b0;
                iorD = 1'b0;
                nextstate = T1;
            end
            T1: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b0;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 2'b11;
                aluOp = 2'b00;
                zero = 1'b0;
                memWr = 1'b0;
                iorD = 1'b0;
                case(opcode)
                    `ADD: nextstate = T2;
                    `BNE: nextstate = T4;
                    default: nextstate = T3;
                endcase    
            end
            T2: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b0;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b1;
                aluSrcB = 2'b00;
                aluOp = 2'b00;
                memWr = 1'b0;
                iorD = 1'b0;
                nextstate = T5;
            end
            T3: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b0;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b1;
                aluSrcB = 2'b10;
                aluOp = 2'b00;
                memWr = 1'b0;
                iorD = 1'b0;
                case (opcode)
                    `ADDI: nextstate = T8;
                    `SW: nextstate = T7;
                    default: nextstate = T6;
                endcase
            end
            T4: begin
                pcWr = 1'b0;
                pcSrc = 1'b1;
                bne = 1'b1;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b0;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b1;
                aluSrcB = 2'b00;
                aluOp = 2'b10;
                memWr = 1'b0;
                iorD = 1'b0;
                nextstate = T0;
            end
            T5: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b1;
                regDest = 1'b1;
                memToReg = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 2'b00;
                aluOp = 2'b00;
                memWr = 1'b0;
                iorD = 1'b0;
                nextstate = T0;
            end
            T6: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b1;
                regWr = 1'b0;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 2'b11;
                aluOp = 2'b00;
                memWr = 1'b0;
                iorD = 1'b1;
                nextstate = T9;
            end
            T7: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b0;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 2'b11;
                aluOp = 2'b00;
                memWr = 1'b1;
                iorD = 1'b1;
                nextstate = T0;
            end
            T8: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b1;
                regDest = 1'b0;
                memToReg = 1'b0;
                aluSrcA = 1'b0;
                aluSrcB = 2'b11;
                aluOp = 2'b00;
                memWr = 1'b0;
                iorD = 1'b0;
                nextstate = T0;
            end
            T9: begin
                pcWr = 1'b0;
                pcSrc = 1'b0;
                bne = 0;
                irWr = 1'b0;
                memRead = 1'b0;
                regWr = 1'b1;
                regDest = 1'b0;
                memToReg = 1'b1;
                aluSrcA = 1'b0;
                aluSrcB = 2'b11;
                aluOp = 2'b00;
                memWr = 1'b0;
                iorD = 1'b1;
                nextstate = T0;
            end
        endcase

    end
endmodule
