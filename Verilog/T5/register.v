`include "flipflop.v"
module register2bit(input wire clk, input rst, input wire [1:0] in, output wire [1:0] out);
    d_flipflop f1(clk, rst, in[0], out[0]);
    d_flipflop f2(clk, rst, in[1], out[1]);
endmodule