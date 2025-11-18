`timescale 1ns / 1ps
`include "serial_mult.v"
module tb_multiplier;

    reg clk, start;
    reg [3:0] A, B;
    wire [7:0] Product;
    wire done;

    serial_multiplier uut (
        .clk(clk), .start(start), 
        .A_in(A), .B_in(B), 
        .Product(Product), .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; start = 0; A = 0; B = 0;

        // Test 1: 6 * 7 = 42 (0010 1010)
        A = 6; B = 7;
        start = 1; #10; // Load
        start = 0;      // Run
        
        wait(done);     // Wait for 8 cycles
        #10;
        $display("6 * 7 = %d (Binary: %b)", Product, Product);

        // Test 2: 15 * 15 = 225
        A = 15; B = 15;
        start = 1; #10;
        start = 0;
        
        wait(done);
        #10;
        $display("15 * 15 = %d (Binary: %b)", Product, Product);

        $finish;
    end
endmodule