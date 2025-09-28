`include "src/count_setbits.v"
`include "src/modulo4_detector.v"
`include "src/d_latch_9bit.v"
`include "src/conditional_adder.v"

// This module should be made Structurally

module top_module (
    input clk, reset, select_player, update,
    output [8:0] scoreA, scoreB
);
    wire [3:0] countA, countB;
    wire [1:0] YA, YB;
    wire [8:0] tA, tB;
    count_setbits CSA(scoreA, countA);
    count_setbits CSB(scoreB, countB);
    modulo4_detector MA(countA, YA);
    modulo4_detector MB(countB, YB);
    conditional_adder CA(scoreA, YA, tA);
    conditional_adder CB(scoreB, YB, tB);
    d_latch_9bit dA(tA, clk, reset, (~select_player)&(update), scoreA);
    d_latch_9bit dB(tB, clk, reset, (select_player)&(update), scoreB);
endmodule

