`include "src/lock.v"

module tb_lock;
    // inputs
    reg clk;
    reg reset_in;
    reg b0_in;
    reg b1_in;
    
    // output
    wire unlock;
    
    lock lock_dut (
        .clk(clk),
        .reset_in(reset_in),
        .b0_in(b0_in),
        .b1_in(b1_in),
        .unlock(unlock)
    );
    
    // clock generation
    always #5 clk = ~clk; // 10ns clock period
    
    // button press
    task press_button;
        input button;
        begin
            if (button == 0) begin
                b0_in = 1; #20; b0_in = 0; #40;
            end else begin
                b1_in = 1; #20; b1_in = 0; #40;
            end
        end
    endtask
    
    initial begin
        $dumpfile("public/vcd/tb_lock.vcd");
        $dumpvars(0, lock_dut);
        
        clk = 0;
        reset_in = 0;
        b0_in = 0;
        b1_in = 0;
        
        $display("\nTesting electronic combination lock.\n");
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        $monitor("|%-9t|%-5b|%-9b|%-9b|%-9b|%-9b|",
            $time, clk, reset_in, b0_in, b1_in, unlock);
        
        // test 1
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(0);
        press_button(1);
        press_button(0);
        press_button(1);
        press_button(1);
        #20;
        $monitoroff;
        if (unlock) $display("\n[TEST 1 - Sequence:01011 - PASS]\n");
        else $display("\n[TEST 1 - Sequence:01011 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 2
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(0);
        press_button(1);
        press_button(0);
        press_button(1);
        press_button(0);
        #20;
        $monitoroff;
        if (!unlock) $display("\n[TEST 2 - Sequence:01010 - PASS]\n");
        else $display("\n[TEST 2 - Sequence:01010 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 3
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(1);
        press_button(1);
        press_button(1);
        press_button(1);
        press_button(1);
        #20;
        $monitoroff;
        if (!unlock) $display("\n[TEST 3 - Sequence:11111 - PASS]\n");
        else $display("\n[TEST 3 - Sequence:11111 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 4
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(0);
        press_button(0);  
        press_button(1);
        press_button(0);
        press_button(1);
        press_button(1);
        #20;
        $monitoroff;
        if (unlock) $display("\n[TEST 4 - Sequence:001011 - PASS]\n");
        else $display("\n[TEST 4 - Sequence:001011 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 5
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(0);
        press_button(0);
        press_button(0);
        press_button(0);
        press_button(0);
        #20;
        $monitoroff;
        if (!unlock) $display("\n[TEST 5 - Sequence:00000 - PASS]\n");
        else $display("\n[TEST 5 - Sequence:00000 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 6
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(0);
        press_button(1);
        press_button(0);
        press_button(0);
        press_button(1);
        #20;
        $monitoroff;
        if (!unlock) $display("\n[TEST 6 - Sequence:01001 - PASS]\n");
        else $display("\n[TEST 6 - Sequence:01001 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 7
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(0);
        press_button(1);
        press_button(0);
        press_button(1);
        press_button(1);
        #20;
        $monitoroff;
        if (unlock) $display("\n[TEST 7 - Sequence:010110110 - PASS]\n");
        else $display("\n[TEST 7 - Sequence:010110110 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // remaining 0110 from test 7
        press_button(0);
        press_button(1);
        press_button(1);
        press_button(0);

        // test 8
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(1); 
        press_button(0);
        press_button(1);
        press_button(0);
        press_button(1);
        press_button(0);
        press_button(1);
        press_button(1);
        #20;
        $monitoroff;
        if (unlock) $display("\n[TEST 8 - Sequence:10101011 - PASS]\n");
        else $display("\n[TEST 8 - Sequence:10101011 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 9
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(0); 
        press_button(1); 
        press_button(0); 
        press_button(0);
        press_button(1); 
        #20;
        $monitoroff;
        if (!unlock) $display("\n[TEST 9 - Sequence:01001 - PASS]\n");
        else $display("\n[TEST 9 - Sequence:01001 - FAIL]\n");
        $monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
            "Time", "clk", "reset", "b0_in", "b1_in", "unlock");
        $display("|---------|-----|---------|---------|---------|---------|");
        
        // test 10
        reset_in = 1; #20; reset_in = 0; #20;
        press_button(1); 
        press_button(1); 
        press_button(1); 
        press_button(1); 
        press_button(1); 
        #20;
        $monitoroff;
        if (!unlock) $display("\n[TEST 10 - Sequence:11111 - PASS]\n");
        else $display("\n[TEST 10 - Sequence:11111 - FAIL]\n");
        
        #20;
        $finish;
    end
    
endmodule
