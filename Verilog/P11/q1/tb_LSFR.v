`include "LSFR.v"
`timescale 1ns/1ps

module testbench;

    reg clk;
    reg set;
    wire [3:0] A;

    // Instantiate DUT
    LSFR dut (
        .clk(clk),
        .set(set),
        .A(A)
    );

    // Generate clock: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Time   clk set  A");
        $monitor("%4t   %b   %b   %b", $time, clk, set, A);

        // Start with reset asserted for 1 cycle
        set = 1;
        #10;

        // Release reset and let LFSR run
        set = 0;

        // Run for some cycles
        #200;

        $finish;
    end

endmodule