/*###################################################################################
Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository.
Kindly remove them, if you have uploaded the previous assignments.
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

module Limit_reg(input clk, input reset, input en,  input [15:0] in_data, output [15:0] out_data, output reg stop);

    Dff d0 (clk, reset, en, in_data[0], out_data[0]);
    Dff d1 (clk, reset, en, in_data[1], out_data[1]);
    Dff d2 (clk, reset, en, in_data[2], out_data[2]);
    Dff d3 (clk, reset, en, in_data[3], out_data[3]);
    Dff d4 (clk, reset, en, in_data[4], out_data[4]);
    Dff d5 (clk, reset, en, in_data[5], out_data[5]);
    Dff d6 (clk, reset, en, in_data[6], out_data[6]);
    Dff d7 (clk, reset, en, in_data[7], out_data[7]);
    Dff d8 (clk, reset, en, in_data[8], out_data[8]);
    Dff d9 (clk, reset, en, in_data[9], out_data[9]);
    Dff d10 (clk, reset, en, in_data[10], out_data[10]);
    Dff d11 (clk, reset, en, in_data[11], out_data[11]);
    Dff d12 (clk, reset, en, in_data[12], out_data[12]);
    Dff d13 (clk, reset, en, in_data[13], out_data[13]);
    Dff d14 (clk, reset, en, in_data[14], out_data[14]);
    Dff d15 (clk, reset, en, in_data[15], out_data[15]);

    always @(*) begin
        if(out_data == 16'b0) begin
            stop = 1'b1;
        end
        else begin
            stop = 1'b0;
        end
    end

endmodule

//implements the limit register, initialised at 10
//decrements by 1 to ensure only 11 memory words (total 22 bytes) are read
//this module is only to store the limit value, and set the stop signal if it is 0