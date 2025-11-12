`timescale 1ns/1ps
`include "register.v"

module tb_Q5;

  // DUT signals
  reg        clk;
  reg        clear;      // async active-high
  reg        MSBin;
  reg        LSBin;
  reg        S1, S0;
  reg  [3:0] D;
  wire [3:0] Q;

  // Instantiate DUT
  register dut (
    .clk   (clk),
    .clear (clear),
    .MSBin (MSBin),
    .LSBin (LSBin),
    .S1    (S1),
    .S0    (S0),
    .D     (D),
    .Q     (Q)
  );

  // Clock: 10 time-unit period
  initial clk = 1'b0;
  always #5 clk = ~clk;

  // Waveform dump
  initial begin
    $dumpfile("tb_Q5.vcd");
    $dumpvars(0, tb_Q5);
  end

  // Monitor
  initial begin
    $display(" time | clk | clr   S1  S0 | D    MSB   LSB | Q");
    $monitor("%0d   |  %b | %b   %b  %b | %b    %b    %b | %b",
             $time, clk, clear, S1, S0, D, MSBin, LSBin, Q);
  end

  // Stimulus
  initial begin
    // Defaults
    clear = 1'b1; MSBin = 1'b0; LSBin = 1'b0; S1 = 1'b0; S0 = 1'b0; D = 4'b0000;

    // Release async clear before first posedge
    #5 clear = 1'b0;

    // ----- 1) Parallel load (S1 S0 = 11)
    D = 4'b1010; S1 = 1'b1; S0 = 1'b1; @(posedge clk);  // Q <- 1010

    // ----- 2) No change (S1 S0 = 00)
    S1 = 1'b0; S0 = 1'b0; @(posedge clk);               // Q stays 1010

    // ----- 3) Shift right (S1 S0 = 01), feed MSBin
    S1 = 1'b0; S0 = 1'b1; MSBin = 1'b1; @(posedge clk); // Q <- {1, Q3, Q2, Q1}
    MSBin = 1'b0; @(posedge clk);                       // another shift right

    // ----- 4) Shift left (S1 S0 = 10), feed LSBin
    S1 = 1'b1; S0 = 1'b0; LSBin = 1'b0; @(posedge clk); // Q <- {Q2, Q1, Q0, 0}
    LSBin = 1'b1; @(posedge clk);                       // another shift left with 1

    // ----- 5) Async clear pulse mid-run
    #5 clear = 1'b1; #5 clear = 1'b0;

    // ----- 6) Parallel load again to confirm recovery
    D = 4'b0111; S1 = 1'b1; S0 = 1'b1; @(posedge clk);  // Q <- 0111

    // ----- 7) One of each quickly to touch all again
    S1 = 1'b0; S0 = 1'b0; @(posedge clk);               // no change
    S1 = 1'b0; S0 = 1'b1; MSBin = 1'b1; @(posedge clk); // shift right
    S1 = 1'b1; S0 = 1'b0; LSBin = 1'b0; @(posedge clk); // shift left

    // Done
    #20 $finish;
  end

endmodule