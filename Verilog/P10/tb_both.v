// Testbench for BCD_Counter (both.v)
// Generates clock, toggles mode for up/down counting, applies reset,
// prints the counter value and creates a VCD file for waveform inspection.
`include "both.v"
`timescale 1ns/1ps

module tb_both();
    reg clk;
    reg rst;
    reg mode; // 0 => up, 1 => down
    wire [3:0] Q;

    // Instantiate DUT
    BCD_Counter dut(.clk(clk), .rst(rst), .mode(mode), .Q(Q));

    // Clock: 10 ns period (100 MHz), toggle every 5 ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // VCD dump for waveform viewers
        $dumpfile("tb_both.vcd");
        $dumpvars(0, tb_both);

        // initialize
        rst = 1'b1;
        mode = 1'b0; // start with up-count
        #17; // wait some time (non-multiple of clock edge to show asynchronous behavior)
        rst = 1'b0; // release reset

        $display("%0t ns: Released reset, starting up-count", $time);

        // Let it count up for several cycles
        #200;

        // Switch to down-counting
        mode = 1'b1;
        $display("%0t ns: Switching to down-count", $time);
        #200;

        // Pulse external reset to observe behavior
        $display("%0t ns: Asserting external reset", $time);
        rst = 1'b1;
        #25;
        rst = 1'b0;
        $display("%0t ns: Released external reset", $time);
        #100;

        $display("%0t ns: Test complete, finishing simulation", $time);
        $finish;
    end

    // Monitor the signals at each clock edge
    always @(negedge clk) begin
        $display("%0t ns | clk=%b rst=%b mode=%b | Q=%b (%0d)", $time, clk, rst, mode, Q, Q);
    end

endmodule
