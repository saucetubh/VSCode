`include "D_ff.v"
module register8bit(input clk, input chipSelect, input reset, input regWrite, input enable, input [7:0] inR, output [7:0] outR);  // DONE    
// Representing Memory as D Flip Flops

    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin : register
            D_ff dff(clk, chipSelect, reset, regWrite, enable, inR[i], outR[i]);
        end
    endgenerate

endmodule