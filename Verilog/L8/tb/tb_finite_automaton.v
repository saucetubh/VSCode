`include "src/finite_automaton.v"

module tb_finite_automaton;
	// inputs
	reg clk;
	reg reset;
	reg in_bit;
	reg in_done;
	
	// output
	wire found;
	
	finite_automaton fa_dut (
		.clk(clk),
		.reset(reset),
		.in_bit(in_bit),
		.in_done(in_done),
		.found(found)
	);
	
	// clock generation
	always #5 clk = ~clk; // 10ns clock period
	
	initial begin
		$dumpfile("public/vcd/tb_finite_automaton.vcd");	
		$dumpvars(0, fa_dut);
		
		clk = 0;
		reset = 0;
		in_bit = 0;
		in_done = 0;
		
		$display("\nTesting finite automaton.\n");
		$display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		$monitor("|%-9t|%-5b|%-9b|%-9b|%-9b|%-9b|",
			$time, clk, reset, in_bit, in_done, found);
		
		// test 1: 00010101
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 1; #10;
		$monitoroff;
		if (found) $display("\n[TEST 1 - Input:00010101 - PASS]\n");
		else $display("\n[TEST 1 - Input:00010101 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
        
		// test 2: 01010000
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 1; #10;
		$monitoroff;
		if (found) $display("\n[TEST 2 - Input:01010000 - PASS]\n");
		else $display("\n[TEST 2 - Input:01010000 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 3: 11111111
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 1; #10;
		$monitoroff;
		if (!found) $display("\n[TEST 3 - Input:11111111 - PASS]\n");
		else $display("\n[TEST 3 - Input:11111111 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 4: 10101000
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 1; #10;
		$monitoroff;
		if (found) $display("\n[TEST 4 - Input:10101000 - PASS]\n");
		else $display("\n[TEST 4 - Input:10101000 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 5: 00000000
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 1; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		$monitoroff;
		if (!found) $display("\n[TEST 5 - Input:00000000 - PASS]\n");
		else $display("\n[TEST 5 - Input:00000000 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 6: 01011010
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 1; #10;
		$monitoroff;
		if (found) $display("\n[TEST 6 - Input:01011010 - PASS]\n");
		else $display("\n[TEST 6 - Input:01011010 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 7: 10111010
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 1; #10;
		$monitoroff;
		if (!found) $display("\n[TEST 7 - Input:10111010 - PASS]\n");
		else $display("\n[TEST 7 - Input:10111010 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 8: 01010101
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 1; #10;
		$monitoroff;
		if (found) $display("\n[TEST 8 - Input:01010101 - PASS]\n");
		else $display("\n[TEST 8 - Input:01010101 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 9: 11010110
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 1; #10;
		$monitoroff;
		if (found) $display("\n[TEST 9 - Input:11010110 - PASS]\n");
		else $display("\n[TEST 9 - Input:11010110 - FAIL]\n");
		$monitoron;
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|%-9s|",
			"Time", "clk", "reset", "in_bit", "in_done", "found");
		$display("|---------|-----|---------|---------|---------|---------|");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		// test 10: 01010000
		reset = 1; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 1; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 0; #10;
		reset = 0; in_bit = 0; in_done = 1; #10;
		$monitoroff;
		if (9) $display("\n[TEST 10 - Input:01010000 - PASS]\n");
		else $display("\n[TEST 10 - Input:01010000 - FAIL]\n");
		reset = 0; in_bit = 0; in_done = 0; #10;
		
		#10;
		$finish;
	end
endmodule
