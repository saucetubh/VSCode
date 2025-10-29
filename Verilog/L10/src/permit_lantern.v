`include "src/tff.v"


module permit_lantern_chain_5bit(
  input clk,
  input reset,
  output [4:0] q
);
  tff t0(clk, 1'b1, reset, q[0]);
  tff t1(q[0], 1'b1, reset, q[1]);
  tff t2(q[1], 1'b1, reset, q[2]);
  tff t3(q[2], 1'b1, reset, q[3]);
  tff t4(q[3], 1'b1, reset, q[4]);
endmodule
