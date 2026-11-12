/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


module pc(input clk, input reset, input regWrite, input [31:0] inPC, output [31:0] outPC);
    Dff_Reg d0  (clk, reset, regWrite, inPC[0],  outPC[0]);
    Dff_Reg d1  (clk, reset, regWrite, inPC[1],  outPC[1]);
    Dff_Reg d2  (clk, reset, regWrite, inPC[2],  outPC[2]);
    Dff_Reg d3  (clk, reset, regWrite, inPC[3],  outPC[3]);
    Dff_Reg d4  (clk, reset, regWrite, inPC[4],  outPC[4]);
    Dff_Reg d5  (clk, reset, regWrite, inPC[5],  outPC[5]);
    Dff_Reg d6  (clk, reset, regWrite, inPC[6],  outPC[6]);
    Dff_Reg d7  (clk, reset, regWrite, inPC[7],  outPC[7]);
    Dff_Reg d8  (clk, reset, regWrite, inPC[8],  outPC[8]);
    Dff_Reg d9  (clk, reset, regWrite, inPC[9],  outPC[9]);
    Dff_Reg d10 (clk, reset, regWrite, inPC[10], outPC[10]);
    Dff_Reg d11 (clk, reset, regWrite, inPC[11], outPC[11]);
    Dff_Reg d12 (clk, reset, regWrite, inPC[12], outPC[12]);
    Dff_Reg d13 (clk, reset, regWrite, inPC[13], outPC[13]);
    Dff_Reg d14 (clk, reset, regWrite, inPC[14], outPC[14]);
    Dff_Reg d15 (clk, reset, regWrite, inPC[15], outPC[15]);
    Dff_Reg d16 (clk, reset, regWrite, inPC[16], outPC[16]);
    Dff_Reg d17 (clk, reset, regWrite, inPC[17], outPC[17]);
    Dff_Reg d18 (clk, reset, regWrite, inPC[18], outPC[18]);
    Dff_Reg d19 (clk, reset, regWrite, inPC[19], outPC[19]);
    Dff_Reg d20 (clk, reset, regWrite, inPC[20], outPC[20]);
    Dff_Reg d21 (clk, reset, regWrite, inPC[21], outPC[21]);
    Dff_Reg d22 (clk, reset, regWrite, inPC[22], outPC[22]);
    Dff_Reg d23 (clk, reset, regWrite, inPC[23], outPC[23]);
    Dff_Reg d24 (clk, reset, regWrite, inPC[24], outPC[24]);
    Dff_Reg d25 (clk, reset, regWrite, inPC[25], outPC[25]);
    Dff_Reg d26 (clk, reset, regWrite, inPC[26], outPC[26]);
    Dff_Reg d27 (clk, reset, regWrite, inPC[27], outPC[27]);
    Dff_Reg d28 (clk, reset, regWrite, inPC[28], outPC[28]);
    Dff_Reg d29 (clk, reset, regWrite, inPC[29], outPC[29]);
    Dff_Reg d30 (clk, reset, regWrite, inPC[30], outPC[30]);
    Dff_Reg d31 (clk, reset, regWrite, inPC[31], outPC[31]);
endmodule
