`timescale 1ns / 1ps
`include "serial_adder.v"
module tb_sa;

    // Inputs
    reg clk;
    reg clr;      // Acts as Load when 1, Run/Add when 0
    reg [3:0] A;
    reg [3:0] B;

    // Outputs
    wire [3:0] S;
    wire carry;

    // Instantiate your Serial Adder
    sa uut (
        .clk(clk), 
        .clr(clr), 
        .A(A), 
        .B(B), 
        .S(S), 
        .carry(carry)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        clr = 0;
        A = 0;
        B = 0;

        // ==========================================
        // Test Case 1: 6 + 7 = 13
        // Binary: 0110 + 0111 = 1101 (Carry 0)
        // ==========================================
        
        // 1. SETUP
        A = 4'b0110; // 6
        B = 4'b0111; // 7
        
        // 2. LOAD (Assert clr)
        clr = 1;     
        #10;         // Wait 1 clock cycle to latch data
        
        // 3. RUN (Release clr)
        clr = 0;     
        #40;         // Wait exactly 4 clock cycles (10ns * 4)

        // 4. CHECK
        $display("Test 1: %d + %d = %d (Carry: %b)", A, B, S, carry);


        // ==========================================
        // Test Case 2: 15 + 1 = 0 (Overflow)
        // Binary: 1111 + 0001 = 0000 (Carry 1)
        // ==========================================
        
        #10;         // Small gap between tests
        
        // 1. SETUP
        A = 4'b1111; // 15
        B = 4'b0001; // 1
        
        // 2. LOAD
        clr = 1;
        #10;
        
        // 3. RUN
        clr = 0;
        #40;         // Wait exactly 4 clock cycles

        // 4. CHECK
        $display("Test 2: %d + %d = %d (Carry: %b)", A, B, S, carry);

        #10;
        $finish;
    end
      
endmodule