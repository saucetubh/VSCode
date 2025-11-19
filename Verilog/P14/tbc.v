`timescale 1ns/1ps
`include "counter.v"
module counter_tb;

    reg clk;
    reg rst;
    wire [2:0] Q;

    // Instantiate DUT
    counter2 uut (
        .clk(clk),
        .rst(rst),
        .Q(Q)
    );

    // Clock: 10ns period
    initial begin
        clk = 1;
        forever #5 clk = ~clk;
    end

    // Stimulus
    initial begin
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, counter_tb);

        // Apply reset
        rst = 1;
        #12;      // allow at least one negedge
        rst = 0;

        // Run long enough to see full sequence
        #200;

        $finish;
    end

    // Display ONLY on negedge (JK FFs triggered on negedge)
    always @(negedge clk) begin
        $display("Time=%0dns  Q=%b", $time, Q);
    end

endmodule