/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

module alu(input [31:0] aluIn1, input [31:0] aluIn2,input [3:0]ALUContrl, output reg [31:0]aluOut, output reg zero);
//WRITE CODE HERE
always @ (aluIn1, aluIn2, ALUContrl)
begin
  if (ALUContrl==4'b0000) 
    aluOut = aluIn1 & aluIn2;
  else if (ALUContrl==4'b0001) 
    aluOut = aluIn1 | aluIn2;
  else if (ALUContrl==4'b0010) 
    aluOut = aluIn1 + aluIn2;
  else if (ALUContrl==4'b0110) 
    aluOut = aluIn1 - aluIn2;
  else if (ALUContrl==4'b0111) 
  begin
    if (aluIn1 < aluIn2)
      aluOut=32'd1;
    else if(aluIn1 > aluIn2)
      aluOut=32'd0;
  end
  else if (ALUContrl==4'b1100) 
    aluOut = ~(aluIn1 | aluIn2);

  if(aluOut==32'b0)
    zero=1'b1;
  else
    zero=1'b0;

end
endmodule

// follow the table given in question pdf
module aluCtrl(input [1:0] aluOp, input [5:0] func,output reg [3:0] ALUContrl);
//WRITE CODE HERE
always @ (aluOp, func)
begin
  if(aluOp==2'b00)
    ALUContrl=4'b0010;
  else if (aluOp[0]==1'b1)
      ALUContrl=4'b0110;
  else
    begin
      if(func[3:0] == 4'b0000)
        ALUContrl=4'b0010;
      else if(func[3:0] == 4'b0010)
        ALUContrl=4'b0110;
      else if(func[3:0] == 4'b0100)
        ALUContrl=4'b0000;
      else if(func[3:0] == 4'b0101)
        ALUContrl=4'b0001;
      else if(func[3:0] == 4'b1010)
        ALUContrl=4'b0111;
    end
end
endmodule


