`timescale 1ns/1ps
`include "src/code_progressor.v"

module tb_code_progressor;
	// Inputs
	reg clk;
	reg armed;
	reg code_bit;
	// Output
	wire [1:0] stage;
	// Instantiate DUT
	code_progressor dut (
		.clk(clk),
		.armed(armed),
		.code_bit(code_bit),
		.stage(stage)
	);
	// Clock generation
	always #5 clk = ~clk; // 10ns period
	initial begin
	$dumpfile("public/vcd/tb_code_progressor.vcd");
	$dumpvars(0, dut);
		clk = 0;
		armed = 0;
		code_bit = 0;
		$display("\nTesting code_progressor\n");
		$display("|%-9s|%-5s|%-9s|%-9s|%-9s|",
			"Time", "clk", "armed", "code_bit", "stage");
		$display("|---------|-----|---------|---------|---------|");
		$monitor("|%-9t|%-5b|%-9b|%-9b|%-9b|",
			$time, clk, armed, code_bit, stage);
		// --- Test sequence ---
		// Reset / idle
		armed = 0; code_bit = 0; #10;
		armed = 0; code_bit = 1; #10;
		// Armed, progress through code bits
		armed = 1; code_bit = 1; #10;
		armed = 1; code_bit = 0; #10;
		armed = 1; code_bit = 1; #10;
		armed = 1; code_bit = 0; #10;
		// Disarm resets stage
		armed = 0; code_bit = 0; #10;
		// Another armed sequence
		armed = 1; code_bit = 1; #10;
		armed = 1; code_bit = 1; #10;
		armed = 1; code_bit = 0; #10;
		armed = 1; code_bit = 1; #10;
		#10; $monitoroff;
		$finish;
	end
endmodule