/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/

module comparator (input [31:0] in1, input [31:0] in2, output reg equal);
    //WRITE YOUR CODE HERE
    always @(in1, in2) begin
        if(in1 == in2)
            equal = 1'b1;
        else
            equal = 1'b0;
    end
   
endmodule
