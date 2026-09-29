/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

//perform airthemtic or logical operations based on value of "ALUControl"
module ALU(input [31:0] aluIn1, input [31:0] aluIn2,input [3:0]ALUContrl, output reg [31:0]aluOut, output reg zero);
//WRITE YOUR CODE HERE
  always @(*) begin
    case (ALUContrl)
      4'b0000: aluOut = aluIn1 & aluIn2;
      4'b0001: aluOut = aluIn1 | aluIn2;
      4'b0010: aluOut = aluIn1 + aluIn2;
      4'b0110: aluOut = aluIn1 - aluIn2;
      4'b0111: aluOut = (aluIn1 < aluIn2);        
    endcase
    zero = (aluOut == 0);
  end
endmodule

// follow the table given in question pdf
module aluCtrl(input [1:0] aluOp, input [5:0] func,output reg [3:0] ALUContrl);
//WRITE YOUR CODE HERE
  always @(*) begin
      case (aluOp)
          2'b00: ALUContrl = 4'b0010;
          2'b01: ALUContrl = 4'b0110;
          2'b10: begin
              case (func)
                  6'b100000: ALUContrl = 4'b0010;
                  6'b100010: ALUContrl = 4'b0110;
                  6'b100100: ALUContrl = 4'b0000;
                  6'b100101: ALUContrl = 4'b0001;
                  6'b101010: ALUContrl = 4'b0111;
              endcase
          end
      endcase
  end
endmodule