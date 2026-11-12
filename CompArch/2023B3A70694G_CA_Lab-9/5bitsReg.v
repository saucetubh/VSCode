/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


module register5bit(input clk, input reset, input regWrite, input [4:0] inR, output [4:0] outR);
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    genvar i;
    generate
        for(i=0;i<5;i = i + 1)
            Dff_Reg d5bits  (clk, reset, regWrite, inR[i],  outR[i]);
    endgenerate
    /*Dff_Reg d0  (clk, reset, regWrite, inR[0],  outR[0]);
    Dff_Reg d1  (clk, reset, regWrite, inR[1],  outR[1]);
    Dff_Reg d2  (clk, reset, regWrite, inR[2],  outR[2]);
    Dff_Reg d3  (clk, reset, regWrite, inR[3],  outR[3]);
    Dff_Reg d4  (clk, reset, regWrite, inR[4],  outR[4]);*/    
endmodule

