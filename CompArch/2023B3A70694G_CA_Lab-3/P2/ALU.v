/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository.
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

//perform airthemtic or logical operations based on value of "ALUControl"

module ALU(input [31:0] aluIn1, input [31:0] aluIn2, input [3:0]ALUContrl, output reg [31:0]aluOut, output reg zero);
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
module aluCtrl(input [1:0] aluOp, input [5:0] func, output reg [3:0] ALUContrl);

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

module testbench(); // output will be observed as  Wave form
  //inputs
  reg [31:0] aluIn1, aluIn2;
  reg [1:0] aluOp;
  reg [5:0] func;

  //outputs
  wire [31:0]aluOut;
  wire [3:0]ALUContrl;
  wire zero;
  
  aluCtrl ac(aluOp, func, ALUContrl);
  ALU alu1(aluIn1, aluIn2, ALUContrl, aluOut, zero);
  
  initial
  begin
    aluOp        = 2'd0;
    func         = 6'd0;
    aluIn1       = 32'b0;
    aluIn2       = 32'b0;

    $dumpfile("2023B3A70694G_Alu_Control_CA_Lab-3.vcd"); 
    $dumpvars(0, testbench);
    //define all test cases given in the PDF file.
    //ADD, SUB, AND, OR and SLT
    //Change the operation after every 10 unit of time.
    aluIn1 = 32'd15; aluIn2 = 32'd10;
    #10 aluOp = 2'b00;
    #10 aluOp = 2'b01; aluIn1 = 32'd20; aluIn2 = 32'd10;
    #10 func = 6'b100100; aluOp = 2'b10; aluIn1 = 32'd30; aluIn2 = 32'd10;
    #10 func = 6'b100101; aluOp = 2'b10; aluIn1 = 32'd15; aluIn2 = 32'd31;
    #10 func = 6'b101010; aluOp = 2'b10; aluIn1 = 32'd10; aluIn2 = 32'd15;
    #10 $finish;
  end
endmodule

