// tb_shift_reg.v
`timescale 1ns/1ps
`include "shift_reg.v"

module tb_shift_reg;
    reg clk;
    reg reset;
    reg in_bit;
    wire [3:0] q;

    // Instantiate the shift register
    shift_reg uut (
        .clk(clk),
        .reset(reset),
        .in_bit(in_bit),
        .q(q)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk; // toggles every 5 ns

    initial begin
        // Initialize
        
        in_bit = 0;
        reset = 0;  // start with reset
        $display("Time(ns) | Reset | Input | Shift Register");
        $display("---------------------------------------");

        //#10 reset = 1; // release reset after 10 ns (1st cycle)

        #10 reset = 0;
        // Apply a sequence of bits
        // Show two cycles without reset
        in_bit = 1; #10;   // t=10
        in_bit = 0; #10;   // t=20
        in_bit = 1; #10;   // t=30
        in_bit = 1; #10;   // t=40
        in_bit = 0; #10;   // t=50
        in_bit = 1; #10;   // t=60
        in_bit = 0; #10;   // t=70
        in_bit = 1; #10;   // t=80

        #20 $finish; // end simulation at t=100 ns
    end

    // Display shift register value at every positive clock edge
    always @(posedge clk) begin
        $display("%8d |   %b   |   %b   |      %b", $time, reset, in_bit, q);
    end
endmodule
