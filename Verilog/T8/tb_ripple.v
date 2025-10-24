// tb_ripple_counter_4bit.v
`timescale 1ns/1ps
`include "4bit_ripple.v"
module tb_ripple_counter_4bit;

    // Testbench signals
    reg clk;
    reg reset;
    wire [3:0] q;

    // Instantiate the DUT (Device Under Test)
    ripple_counter_4bit uut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    // Clock generation: 10ns period → 100MHz clock
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Apply reset for a short duration
        #10;
        reset = 0;

        // Let the counter run for a while
        #200;

        // Apply reset again to verify reset behavior
        reset = 1;
        #10;
        reset = 0;

        // Run for some more time
        #100;

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time\tReset\tQ");
        $monitor("%0t\t%b\t%b", $time, reset, q);
    end

endmodule
