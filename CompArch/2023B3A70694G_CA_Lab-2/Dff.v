/*###################################################################################
Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository.
Kindly remove them, if you have uploaded the previous assignments.
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

module Dff(input clk, input reset, input regWrite, input d, output reg q);
    always @(posedge clk) begin
        if (reset) begin //synchronous reset since it happens only on clock's rising edge
            q <= d;
        end
        else if(regWrite) begin
            q <= d; //non blocking assignment for sequential circuits
        end
    end
endmodule

