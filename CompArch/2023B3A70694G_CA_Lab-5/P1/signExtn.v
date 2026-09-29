/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
module signExt16to32(input [15:0] in, output reg [31:0] signExtIn);
   always@(in)
    begin
        signExtIn={{16{in[15]}},in};
    end
endmodule