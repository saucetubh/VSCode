/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

//IF select is 0 then muxout is in0. IF select is 1 then muxout is in1. 
module mux4to1_32bits(input [31:0] in0, input [31:0] in1, input [31:0] in2, input [31:0] in3, input [1:0] select, output reg [31:0] muxOut);
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
	always @(in0, in1, in2, in3, select) begin
        case (select)
            2'b00: muxOut = in0;
            2'b01: muxOut = in1;
            2'b10: muxOut = in2;
            2'b11: muxOut = in3; 
        endcase
    end
endmodule