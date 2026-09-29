/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
module adder(input [31:0] in1, input [31:0] in2, output reg [31:0] adderOut);
      //Write Your Code Here
	always@(in1, in2)
    begin
        adderOut = in1 + in2;
    end
endmodule

