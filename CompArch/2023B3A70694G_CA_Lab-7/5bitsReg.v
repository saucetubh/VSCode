/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/
//The Dff_Reg will be used for making the pipeline registers

module register5bit(input clk, input reset, input regWrite, input [4:0] inR, output [4:0] outR);
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    genvar i;
    generate
        for(i = 0; i < 5; i = i + 1)
            Dff_Reg dreg(clk, reset, regWrite, inR[i], outR[i]);
    endgenerate
endmodule

