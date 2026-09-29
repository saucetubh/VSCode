/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
module mux2to1_5bits(input [4:0] in0, input [4:0] in1, input select, output reg [4:0] muxOut);
    always@(in0, in1, select)
    begin
        case(select)
            2'b00: muxOut = in0;
            2'b01: muxOut = in1;
        endcase
    end
endmodule