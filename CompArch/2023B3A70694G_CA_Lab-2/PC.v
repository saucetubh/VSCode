/*###################################################################################
Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository.
Kindly remove them, if you have uploaded the previous assignments.
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
`include "Dff.v"

module PC_reg(input clk, input reset, input PC_Update, input [15:0] PC_inData,  output [15:0] PC_outData);
    Dff d0 (clk, reset, PC_Update, PC_inData[0], PC_outData[0]);
    Dff d1 (clk, reset, PC_Update, PC_inData[1], PC_outData[1]);
    Dff d2 (clk, reset, PC_Update, PC_inData[2], PC_outData[2]);
    Dff d3 (clk, reset, PC_Update, PC_inData[3], PC_outData[3]);
    Dff d4 (clk, reset, PC_Update, PC_inData[4], PC_outData[4]);
    Dff d5 (clk, reset, PC_Update, PC_inData[5], PC_outData[5]);
    Dff d6 (clk, reset, PC_Update, PC_inData[6], PC_outData[6]);
    Dff d7 (clk, reset, PC_Update, PC_inData[7], PC_outData[7]);
    Dff d8 (clk, reset, PC_Update, PC_inData[8], PC_outData[8]);
    Dff d9 (clk, reset, PC_Update, PC_inData[9], PC_outData[9]);
    Dff d10 (clk, reset, PC_Update, PC_inData[10], PC_outData[10]);
    Dff d11 (clk, reset, PC_Update, PC_inData[11], PC_outData[11]);
    Dff d12 (clk, reset, PC_Update, PC_inData[12], PC_outData[12]);
    Dff d13 (clk, reset, PC_Update, PC_inData[13], PC_outData[13]);
    Dff d14 (clk, reset, PC_Update, PC_inData[14], PC_outData[14]);
    Dff d15 (clk, reset, PC_Update, PC_inData[15], PC_outData[15]);
endmodule

//16 bit register to store the address of the memory location being read (5 bit address stored in a 16bit register)