/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

//IF select is 0 then muxout is in0. IF select is 1 then muxout is in1. 
module mux2to1_32bits(input [31:0] in0, input [31:0] in1, input select, output reg [31:0] muxOut);
    always@(in0, in1, select)
    begin
        case(select)
            1'b0: muxOut = in0;
            1'b1: muxOut = in1;
        endcase
    end
endmodule