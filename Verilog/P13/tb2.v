`timescale 1ns / 1ps
`include "serial_adder.v"
module tb_sa;

    // Inputs
    reg clk;
    reg clr;
    reg [3:0] A;
    reg [3:0] B;

    // Outputs
    wire [3:0] S;
    wire carry;

    // Instantiate the Unit Under Test (UUT)
    sa uut (
        .clk(clk), 
        .clr(clr), 
        .A(A), 
        .B(B), 
        .S(S), 
        .carry(carry)
    );

    // Clock generation
    always #5 clk = ~clk;

    // ============================================================
    // DEBUG BLOCK: Print status every Clock Cycle
    // ============================================================
    // We trigger on NEGEDGE to see the values *after* they 
    // have settled from the rising edge update.
    always @(negedge clk) begin
        // We use "uut.u2.Q" to peek inside the 'u2' instance (Register B)
        // 'S' allows us to see Register A.
        $display("Time: %3d ns | Clr: %b | Reg A (Sum): %b | Reg B: %b | CarryFF: %b", 
                 $time, clr, S, uut.u2.Q, uut.d1.q); 
    end

    initial begin
        // Setup
        clk = 0;
        clr = 0;
        A = 0;
        B = 0;
        
        $display("-----------------------------------------------------------------");
        $display("STARTING SIMULATION");
        $display("-----------------------------------------------------------------");

        // --- TEST CASE: 6 + 7 = 13 ---
        // A = 0110
        // B = 0111
        
        // 1. LOAD PHASE
        A = 4'b0110;
        B = 4'b0111;
        clr = 1;  // Assert Clear/Load
        #10;      // Wait for one clock edge to load data
        
        $display("--- Data Loaded. Starting Addition ---");

        // 2. CALCULATION PHASE (4 Cycles)
        clr = 0;  // Release Clear -> Starts Shifting
        #40;      // Wait 4 cycles
        
        $display("--- Calculation Finished ---");
        $display("FINAL RESULT: %d + %d = %d (Expected 13)", A, B, S);
        
        $finish;
    end
      
endmodule