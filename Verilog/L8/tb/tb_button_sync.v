`include "src/button_sync.v"

module tb_button_sync;
    // inputs
    reg clk;
    reg in;
    
    // output
    wire out;
    
    button_sync bs_dut (clk, in, out);
    
    // clock generation
    always #5 clk = ~clk; // 10ns clock period
    
    initial begin
        $dumpfile("public/vcd/tb_button_sync.vcd");
        $dumpvars(0, bs_dut);
        
        clk = 0;
        in = 0;
        
        $display("\nTesting button synchronizer.\n");
        $display("|%-9s|%-5s|%-9s|%-9s|",
            "Time", "clk", "in", "out");
        $display("|---------|-----|---------|---------|");
        $monitor("|%-9t|%-5b|%-9b|%-9b|",
            $time, clk, in, out);
        
        // test 1
        in = 0; #20;
        in = 1; #20;
        in = 0; #20;
        $monitoroff;
        if (!out) $display("\n[TEST 1 - PASS]\n");
        else $display("\n[TEST 1 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|",
            "Time", "clk", "in", "out");
        $display("|---------|-----|---------|---------|");
        
        // test 2
        in = 0; #10;
        in = 1; #1; 
        in = 0; #1;  
        in = 1; #1;  
        in = 0; #1;  
        in = 1; #16; 
        in = 0; #20;
        $monitoroff;
        $display("\n[TEST 2 - PASS]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|",
            "Time", "clk", "in", "out");
        $display("|---------|-----|---------|---------|");
        
        // test 3
        in = 0; #10;
        in = 1; #50;
        in = 0; #20;
        $monitoroff;
        if (!out) $display("\n[TEST 3 - PASS]\n");
        else $display("\n[TEST 3 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|",
            "Time", "clk", "in", "out");
        $display("|---------|-----|---------|---------|");
        
        // test 4
        in = 0; #10;
        in = 1; #2; 
        in = 0; #2; 
        in = 1; #2;
        in = 0; #2;
        in = 1; #2;
        in = 0; #20;
        $monitoroff;
        if (!out) $display("\n[TEST 4 - PASS]\n");
        else $display("\n[TEST 4 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|",
            "Time", "clk", "in", "out");
        $display("|---------|-----|---------|---------|");
        
        // test 5
        in = 0; #10; 
        in = 1; #20; 
        in = 0; #1;  
        in = 1; #1;  
        in = 0; #1;  
        in = 1; #1;  
        in = 0; #16; 
        $monitoroff;
        if (!out) $display("\n[TEST 5 - PASS]\n");
        else $display("\n[TEST 5 - FAIL]\n");
        
        #20;
        $finish;
    end
    
endmodule
