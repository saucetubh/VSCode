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

// Control circuit. Generates the control signals. Default value for all the outputs is zero(0).

module controlCircuit(input [5:0] opcode, output reg [1:0] aluOp, output reg aluSrc, output reg branch, output reg memWrite, output reg memRead, output reg memtoReg, output reg regDest, output reg regWrite );
  
    //WRITE YOUR CODE HER
always @(*) begin
    case (opcode)
        `ADDI : begin
        aluOp = 2'b0;
        aluSrc = 1;
        branch = 0;
        memWrite = 0;
        memRead = 0;
        memtoReg = 0;
        regDest = 0;
        regWrite = 1;
    end
    `LW : begin
        aluOp = 2'b0;
        aluSrc = 1;
        branch = 0;
        memWrite = 0;
        memRead = 1;
        memtoReg = 1;
        regDest = 0;
        regWrite = 1;
    end 
    `SW : begin
        aluOp = 2'b0;
        aluSrc = 1;
        branch = 0;
        memWrite = 1;
        memRead = 0;
        memtoReg = 1'bx;
        regDest = 1'bx;
        regWrite = 0;
    end
    `BNE : begin
        aluOp = 2'b01;
        aluSrc = 0;
        branch = 1;
        memWrite = 0;
        memRead = 0;
        memtoReg = 1'bx;
        regDest = 1'bx;
        regWrite = 0;
    end
    `ADD : begin
        aluOp = 2'b10;
        aluSrc = 0;
        branch = 0;
        memWrite = 0;
        memRead = 0;
        memtoReg = 0;
        regDest = 1;
        regWrite = 1;
    end
    default: begin
        aluOp = 2'bxx;
        aluSrc = 1'bx;
        branch = 1'bx;
        memWrite = 1'bx;
        memRead = 1'bx;
        memtoReg = 1'bx;
        regDest = 1'bx;
        regWrite = 1'bx;
    end
    endcase
end

      
endmodule