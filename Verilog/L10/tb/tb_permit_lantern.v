
`include "src/permit_lantern.v"

module tb_permit_lantern_chain_5bit;
  reg clk;
  reg reset;
  wire [4:0] q;

  permit_lantern_chain_5bit dut(.clk(clk), .reset(reset), .q(q));

  always #5 clk = ~clk;

  initial begin
    clk = 0;

    $display("\n5-bit Ripple Counter (Permit Lantern Chain), active-high reset\n");
    $display("|%-9s|%-5s|%-6s|%-7s|", "Time", "clk", "reset", "q");
    $display("|---------|-----|------|-------|");

    reset = 1; #12;
    reset = 0;
    $monitor("|%-9t|%-5b|%-6b|  %5b|", $time, clk, reset, q);

    repeat (40) #10;

    reset = 1; #10; reset = 0;

    repeat (24) #10;

    $finish;
  end
endmodule