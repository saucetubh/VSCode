`timescale 1ns/1ps
`include "flipflop.v"
module d_flipflop_tb;
    reg clk;
    reg reset_n;
    reg d;
    wire q;

    d_flipflop dut (
        .clk(clk),
        .reset_n(reset_n),
        .d(d),
        .q(q)
    );

    // Clock generation: 100 MHz equivalent toggle every 5 ns
    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        $display("  Time | reset_n d | q");
        $monitor("%6t |    %b     %b | %b", $time, reset_n, d, q);
    end

    initial begin
        reset_n = 1'b0;
        d = 1'b0;
        #12;
        reset_n = 1'b1;

        #8  d = 1'b1;
        #10 d = 1'b0;
        #10 d = 1'b1;
        #10 d = 1'b1;

        // Check asynchronous reset behavior
        #7  reset_n = 1'b0;
        #6  reset_n = 1'b1;

        #10 d = 1'b1;
        #10 d = 1'b0;

        #20;
        $finish;
    end
endmodule
