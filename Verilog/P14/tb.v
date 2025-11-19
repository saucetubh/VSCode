`timescale 1ns/1ps
`include "ring.v"
module ring1_tb;

    reg clk;
    reg rst;
    wire [3:0] Q;

    // Instantiate DUT
    ring2 uut (
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        $dumpfile("ring1_tb.vcd");   // for waveform viewing
        $dumpvars(0, ring1_tb);

        // Apply reset
        rst = 1;
        #20;
        rst = 0;

        // Run for some cycles
        #200;

        $finish;
    end

    // Monitor output every clock
    initial begin
        $display("Time\tclk\trst\tQ");
        $monitor("%0dns\t%b\t%b\t%b", $time, clk, rst, Q);
    end

endmodule