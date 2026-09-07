/*###################################################################################
Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository.
Kindly remove them, if you have uploaded the previous assignments.
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

module triStateBuffer16bit(input [15:0] in, input sel, output reg [15:0] out);
    always @(*) begin
        if(sel) begin
            out = in;
        end
        else begin
            out = 16'bz; //high impedance state when sel is low
        end
    end
endmodule
