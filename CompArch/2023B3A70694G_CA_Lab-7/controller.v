/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/
//MIPS's instruction's Opcode

`define ADDI    6'd8
`define LW      6'd35
`define SW      6'd43
`define BNE     6'd5
`define ADD     6'd0

module controlCircuit(input [5:0] opcode, output reg [1:0] aluOp, output reg aluSrc, output reg branch, output reg memWrite, output reg memRead, output reg memtoReg, output reg regDest, output reg regWrite );
  //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
  always @(opcode) begin
        if(opcode == `ADDI) begin
            aluOp = 2'd0;
            aluSrc = 1'd1;
            branch = 1'd0;
            memWrite = 1'd0;
            memRead = 1'd0;
            memtoReg = 1'd0;
            regDest = 1'd0;
            regWrite = 1'd1;
        end
        else if(opcode == `SW) begin
            aluOp = 2'd0;
            aluSrc = 1'd1;
            branch = 1'd0;
            memWrite = 1'd1;
            memRead = 1'd0;
            memtoReg = 1'd0;
            regDest = 1'd0;
            regWrite = 1'd0;
        end
        else if(opcode == `LW) begin
            aluOp = 2'd0;
            aluSrc = 1'd1;
            branch = 1'd0;
            memWrite = 1'd0;
            memRead = 1'd1;
            memtoReg = 1'd1;
            regDest = 1'd0;
            regWrite = 1'd1;
        end
        else if(opcode == `BNE) begin
            aluOp = 2'd1;
            aluSrc = 1'd1;
            branch = 1'd1;
            memWrite = 1'd0;
            memRead = 1'd0;
            memtoReg = 1'd0;
            regDest = 1'd0;
            regWrite = 1'd0;
        end
        else if(opcode == `ADD) begin
            aluOp = 2'd2;
            aluSrc = 1'd0;
            branch = 1'd0;
            memWrite = 1'd0;
            memRead = 1'd0;
            memtoReg = 1'd0;
            regDest = 1'd1;
            regWrite = 1'd1;
        end     
    end  
    
endmodule

