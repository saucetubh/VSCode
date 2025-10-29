`include "q1.v" //chage acc to whatever file you want to test

module tb_bcd_counter;
  reg clk;
  reg rst;
  wire [3:0] Q;

  BCD_Counter dut(.clk(clk), .rst(rst), .Q(Q));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 1;
    #12 rst = 0;
  end

  initial begin
    $display("|%6s|%4s|%6s|","time","rst","Q");
    $monitor("|%6t|%4b|%6b|",$time,rst,Q);
  end

  initial begin
    #400 $finish;
  end
endmodule

