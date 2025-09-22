//`include "Q2/full_adder.v"
module adder_3bit(input [2:0] in1, input [2:0] in2, output reg [3:0] sum);
  /*
  wire c1, c2;
  full_adder FA1(in1[0], in2[0], 1'b0, sum[0], c1);
  full_adder FA2(in1[1], in2[1], c1, sum[1], c2);
  full_adder FA3(in1[2], in2[2], c2, sum[2], sum[3]);
  */ //this implementation is incorrect since we want output to be reg, but this is continous assignment. To fix this we would hv to create a temp_sum as a wire, implement this. And then inside an always block, do sum = temp_sum since sum is a reg.
  always @(*) begin
    sum = in1 + in2;
  end
endmodule
