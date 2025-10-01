`timescale 1ns/1ps
`include "src/strike_counter.v"

module tb_strike_counter;

    // Inputs
    reg clk;
    reg armed;
    reg strike;

    // Output
    wire [1:0] strikes;

    // Instantiate DUT
    strike_counter dut (
        .clk(clk),
        .armed(armed),
        .strike_bit(strike),
        .strikes(strikes)
    );

    // Clock generation
    always #1 clk = ~clk;  // 2ns clock period

    initial begin
        clk    = 0;
        armed  = 0;
        strike = 0;

        $display("\nTesting strike_counter\n");
        $display("|%-9s|%-5s|%-7s|%-7s|", 
                 "Time", "clk", "armed", "strike", "strikes");
        $display("|---------|-----|-------|-------|---------|");
        $monitor("|%-9t|%-5b|%-7b|%-7b|%-7b|", 
                 $time, clk, armed, strike, strikes);

        // --- Test sequence ---

        // Reset state (armed=0, strikes=0)
        armed = 0; strike = 0; #2;

        // Arm without striking
        armed = 1; strike = 0; #2;

        // Apply strikes to ramp counter
        strike = 1; #2;
        strike = 0; #2;
        strike = 1; #2;
        strike = 0; #2;

        // Mix armed/strike combinations
        armed = 0; strike = 1; #2;
        armed = 1; strike = 1; #2;
        armed = 1; strike = 0; #2;

        // Reset again
        armed = 0; strike = 0; #2;

        #2; $monitoroff;
        $finish;
    end
endmodule
