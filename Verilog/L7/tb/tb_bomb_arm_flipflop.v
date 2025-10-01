`timescale 1ns/1ps
`include "src/bomb_arm_flipflop.v"
module tb_bomb_arm_flipflop;
	// Inputs
	reg clk;
	reg arm_cmd;
	reg reset_cmd;
	// Output
	wire armed;
	// Instantiate DUT
	bomb_arm_flipflop dut (
		.clk(clk),
		.arm_cmd(arm_cmd),
		.reset_cmd(reset_cmd),
		.armed(armed)
	);
	// Clock generation
	always #5 clk = ~clk; // 10ns clock period
	initial begin
	$dumpfile("public/vcd/tb_bomb_arm_flipflop.vcd");	
	$dumpvars(0, dut);
		clk = 0;
		arm_cmd = 0;
		reset_cmd = 0;
		$display("\nTesting bomb_arm_flipflop\n");
		$display("|%-9s|%-5s|%-9s|%-9s|%-9s|",
			"Time", "clk", "arm_cmd", "reset_cmd", "armed");
		$display("|---------|-----|---------|---------|---------|");
		$monitor("|%-9t|%-5b|%-9b|%-9b|%-9b|",
			$time, clk, arm_cmd, reset_cmd, armed);
		// --- Test sequence ---
		reset_cmd = 1; arm_cmd = 0; #10;
		reset_cmd = 0; arm_cmd = 0; #10;
		reset_cmd = 0; arm_cmd = 1; #10;
		reset_cmd = 0; arm_cmd = 0; #10;
		reset_cmd = 1; arm_cmd = 0; #10;
		reset_cmd = 0; arm_cmd = 1; #10;
		reset_cmd = 0; arm_cmd = 0; #10;
		reset_cmd = 1; arm_cmd = 1; #10;
        #10; $monitoroff;
		$finish;
	end
endmodule