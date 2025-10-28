`include "q2.v"
module tb_seq_counter;
  reg clk, rst;
  wire [2:0] q;

  seq_counter dut(.clk(clk), .rst(rst), .q(q));

  always #5 clk = ~clk;

  initial begin
    clk = 0; rst = 1;
    $display("\nSequence Counter Simulation (0,2,3,5,6,...)");
    $display("|  Time | clk | rst | q2 q1 q0 | dec |");

    repeat (2) @(posedge clk);
    rst = 0;

    repeat (25) begin
      @(posedge clk);
      $display("| %4t |  %0b  |  %0b  |  %0b  %0b  %0b |  %0d  |",
               $time, clk, rst, q[2], q[1], q[0], q);
    end

    $finish;
  end
endmodule