/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/


//The Dff_Reg will be used for making the pipeline registers


module register1bit(input clk, input reset, input regWrite, input inR, output outR);
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    Dff_Reg d0  (clk, reset, regWrite, inR,  outR);
endmodule	 

