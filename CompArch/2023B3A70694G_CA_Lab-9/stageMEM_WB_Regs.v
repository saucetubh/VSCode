/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/

module MEM_WB(input clk, input reset, input regWr, input memToReg, input regWrite, input [4:0] destReg, 
				  input [31:0] memData, input [31:0] aluOut, output memToReg_MEM_WB, output regWrite_MEM_WB, 
				  output [4:0] destReg_MEM_WB, output [31:0] memData_MEM_WB, output [31:0] aluOut_MEM_WB);
	
    register1bit memToReg0 (clk, reset, regWr, memToReg, memToReg_MEM_WB);
    register1bit regWrite0 (clk, reset, regWr, regWrite, regWrite_MEM_WB);
    register5bit destReg0 (clk, reset, regWr, destReg, destReg_MEM_WB);
    register32bit memData0 (clk, reset, regWr, memData, memData_MEM_WB);
	register32bit aluOut0 (clk, reset, regWr, aluOut, aluOut_MEM_WB);

endmodule
