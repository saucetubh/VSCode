/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


module register32bit(input clk, input reset, input regWrite, input [31:0] inR, output [31:0] outR);
    Dff_Reg d0  (clk, reset, regWrite, inR[0],  outR[0]);
    Dff_Reg d1  (clk, reset, regWrite, inR[1],  outR[1]);
    Dff_Reg d2  (clk, reset, regWrite, inR[2],  outR[2]);
    Dff_Reg d3  (clk, reset, regWrite, inR[3],  outR[3]);
    Dff_Reg d4  (clk, reset, regWrite, inR[4],  outR[4]);
    Dff_Reg d5  (clk, reset, regWrite, inR[5],  outR[5]);
    Dff_Reg d6  (clk, reset, regWrite, inR[6],  outR[6]);
    Dff_Reg d7  (clk, reset, regWrite, inR[7],  outR[7]);
    Dff_Reg d8  (clk, reset, regWrite, inR[8],  outR[8]);
    Dff_Reg d9  (clk, reset, regWrite, inR[9],  outR[9]);
    Dff_Reg d10 (clk, reset, regWrite, inR[10], outR[10]);
    Dff_Reg d11 (clk, reset, regWrite, inR[11], outR[11]);
    Dff_Reg d12 (clk, reset, regWrite, inR[12], outR[12]);
    Dff_Reg d13 (clk, reset, regWrite, inR[13], outR[13]);
    Dff_Reg d14 (clk, reset, regWrite, inR[14], outR[14]);
    Dff_Reg d15 (clk, reset, regWrite, inR[15], outR[15]);
    Dff_Reg d16 (clk, reset, regWrite, inR[16], outR[16]);
    Dff_Reg d17 (clk, reset, regWrite, inR[17], outR[17]);
    Dff_Reg d18 (clk, reset, regWrite, inR[18], outR[18]);
    Dff_Reg d19 (clk, reset, regWrite, inR[19], outR[19]);
    Dff_Reg d20 (clk, reset, regWrite, inR[20], outR[20]);
    Dff_Reg d21 (clk, reset, regWrite, inR[21], outR[21]);
    Dff_Reg d22 (clk, reset, regWrite, inR[22], outR[22]);
    Dff_Reg d23 (clk, reset, regWrite, inR[23], outR[23]);
    Dff_Reg d24 (clk, reset, regWrite, inR[24], outR[24]);
    Dff_Reg d25 (clk, reset, regWrite, inR[25], outR[25]);
    Dff_Reg d26 (clk, reset, regWrite, inR[26], outR[26]);
    Dff_Reg d27 (clk, reset, regWrite, inR[27], outR[27]);
    Dff_Reg d28 (clk, reset, regWrite, inR[28], outR[28]);
    Dff_Reg d29 (clk, reset, regWrite, inR[29], outR[29]);
    Dff_Reg d30 (clk, reset, regWrite, inR[30], outR[30]);
    Dff_Reg d31 (clk, reset, regWrite, inR[31], outR[31]);
endmodule
