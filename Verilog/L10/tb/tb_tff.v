`include "src/tff.v"
module tb_tff;
  reg clk;
  reg t;
  reg reset;
  wire q;

  tff dut(.clk(clk), .t(t), .reset(reset), .q(q));

  always #5 clk = ~clk;

  initial begin
    clk = 0; t = 0; reset = 0;

    $display("\nTesting T Flip-Flop (active-high reset)\n");
    $display("|%-9s|%-5s|%-6s|%-3s|%-3s|", "Time", "clk", "reset", "t", "q");
    $display("|---------|-----|------|---|---|");

    reset = 1; #12;
    reset = 0; #8;
    $monitor("|%-9t|%-5b|%-6b|%-3b|%-3b|", $time, clk, reset, t, q);

    t = 1;  repeat(4) #10;
    t = 0;  repeat(3) #10;
    t = 1;  repeat(5) #10;

    reset = 1; #10; reset = 0; #10;
    t = 1;  repeat(3) #10;

    $finish;
  end
endmodule