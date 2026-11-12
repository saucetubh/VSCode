/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


module ID_EX(input clk, input reset, input regWr, input [31:0] regRs, input [31:0] regRt, 
				 input regDest, input aluSrcB, input [1:0] aluOp, input memRead, input memWrite, input memToReg, 
				 input regWrite, input [31:0] sext16to32,input [4:0] rs, input [4:0] rt, input [4:0] rd, input [31:0]pc, 
                 output [31:0] regRs_ID_EX, 
				 output [31:0] regRt_ID_EX, output regDest_ID_EX, output aluSrcB_ID_EX, output [1:0] aluOp_ID_EX, 
				 output memRead_ID_EX, output memWrite_ID_EX, output memToReg_ID_EX, output regWrite_ID_EX,
				 output [31:0] signext16to32_ID_EX,output [4:0] rs_ID_EX, output [4:0] rt_ID_EX, output [4:0] rd_ID_EX, output [31:0] pc_ID_EX);
	
    
    register32bit regRs0(clk, reset, regWr, regRs, regRs_ID_EX);
    register32bit regRt0(clk, reset, regWr, regRt, regRt_ID_EX);
    register1bit regDest0 (clk, reset, regWr, regDest, regDest_ID_EX);
    register1bit aluSrcB0 (clk, reset, regWr, aluSrcB, aluSrcB_ID_EX);
    register2bit aluOp0 (clk, reset, regWr, aluOp, aluOp_ID_EX);
    register1bit memRead0 (clk, reset, regWr, memRead, memRead_ID_EX);
    register1bit memWrite0 (clk, reset, regWr, memWrite, memWrite_ID_EX);
    register1bit memToReg0 (clk, reset, regWr, memToReg, memToReg_ID_EX);
    register1bit regWrite0 (clk, reset, regWr, regWrite, regWrite_ID_EX);
    register32bit sext16to320 (clk, reset, regWr, sext16to32, signext16to32_ID_EX);
    register5bit rs0 (clk, reset, regWr, rs, rs_ID_EX); 
    register5bit rt0 (clk, reset, regWr, rt, rt_ID_EX);
    register5bit rd0 (clk, reset, regWr, rd, rd_ID_EX);
    register32bit pc0 (clk, reset, regWr, pc, pc_ID_EX);

endmodule
