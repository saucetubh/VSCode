/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/

module controlCircuit(input [5:0] opcode, output reg [1:0] aluOp, output reg aluSrc, output reg branch, output reg memWrite, output reg memRead, output reg memtoReg, output reg regDest, output reg regWrite );
  
    always @ (opcode)
    begin 
        case(opcode)
        6'd8: begin 
                aluOp <= 2'b00;
                aluSrc <= 1'b1; 
                branch <= 1'b0;
                memWrite <= 1'b0;
                memRead <= 1'b0;
                memtoReg <= 1'b0;
                regDest <= 1'b0;
                regWrite <= 1'b1;
            end
        6'd35: begin
                aluOp <= 2'b00;
                aluSrc <= 1'b1;
                branch <= 1'b0;
                memWrite <= 1'b0;
                memRead <= 1'b1;
                memtoReg <= 1'b1;
                regDest <= 1'b0;
                regWrite <= 1'b1;
            end
        6'd43: begin
                aluOp <= 2'b00;
                aluSrc <= 1'b1;
                branch <= 1'b0;
                memWrite <= 1'b1;
                memRead <= 1'b0;
                memtoReg <= 1'b0;
                regDest <= 1'b0;
                regWrite <= 1'b0;
            end
        6'd5: begin 
            aluOp <= 2'b01;
            aluSrc <= 1'b0;
            branch <= 1'b1;
            memWrite <= 1'b0;
            memRead <= 1'b0;
            memtoReg <= 1'b0;
            regDest <= 1'b0;
            regWrite <= 1'b0;
        end
        6'd0: begin 
            aluOp <= 2'b10;
            aluSrc <= 1'b0;
            branch <= 1'b0;
            memWrite <= 1'b0;
            memRead <= 1'b0;
            memtoReg <= 1'b0;
            regDest <= 1'b1;
            regWrite <= 1'b1;
        end
        endcase
    end
    
endmodule
