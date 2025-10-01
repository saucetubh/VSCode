`timescale 1ns/1ps
`include "src/bomb_defusal_top.v"

    

module tb_bomb_defusal_top;
    // Inputs
    reg clk;
    reg arm_key;
    reg code_bit;
    // Output
    wire safe;
    
    // Instantiate DUT
    bomb_defusal_top dut (
        .clk(clk),
        .arm_key(arm_key),
        .code_bit(code_bit),
        .safe(safe)
    );
    
    // Clock generation
    always #5 clk = ~clk; // 10ns period
    
    initial begin
        clk = 0;
        arm_key = 0;
        code_bit = 0;
        
        $display("\nTesting bomb_defusal_top\n");
        // Header
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-7s|%-7s|%-8s|%-6s|",
            "Time", "clk", "arm_key", "code_bit", "safe", "armed", "stage", "strikes", "time");

        // Separator
        $display("|---------|-----|---------|---------|---------|-------|-------|--------|------|");

        // Monitor
        $monitor("|%-9t|%-5b|%-9b|%-9b|%-9b|%-7b|%-7b|%-8b|%-6b|",
            $time, clk, arm_key, code_bit, safe, 
            dut.armed, dut.stage, dut.strikes, dut.time_left);
        arm_key = 0; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        arm_key = 1; code_bit = 1; #10;
        arm_key = 1; code_bit = 0; #10;
        // Disarm
        arm_key = 0; code_bit = 0; #10;
        
        arm_key = 0; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        
        // Disarm
        arm_key = 0; code_bit = 0; #10;
        
        arm_key = 0; code_bit = 0; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        
        // Disarm
        arm_key = 0; code_bit = 0; #10;
        
        arm_key = 0; code_bit = 0; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
        arm_key = 1; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10;
      
        // Disarm
        arm_key = 0; code_bit = 0; #10;
        
        arm_key = 0; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10; 
        arm_key = 1; code_bit = 0; #10; 
        arm_key = 1; code_bit = 1; #10; 
        arm_key = 1; code_bit = 1; #10; 
        arm_key = 1; code_bit = 0; #10; 
        arm_key = 1; code_bit = 1; #10; 
      
        // Disarm
        arm_key = 0; code_bit = 0; #10;
        
        arm_key = 0; code_bit = 0; #10;
        arm_key = 1; code_bit = 1; #10; 
        arm_key = 1; code_bit = 0; #10; 
        arm_key = 1; code_bit = 1; #10; 
        arm_key = 1; code_bit = 1; #10; 
        arm_key = 1; code_bit = 0; #10; 
        arm_key = 1; code_bit = 1; #10; 
        
        #20;
        $monitoroff;
        $finish;
    end
endmodule