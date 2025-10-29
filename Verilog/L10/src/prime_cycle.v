`include "src/dff.v"
module prime_counter_struct (
  input clk,
  input reset,
  output [3:0] q
);
wire A, B, C, D;
wire dd, dc, db, da;
assign dd = (~A)|(~B);
assign dc = (~C)|(B)|(~D);
assign db = ((~A)&(~C))|((~B)&(D));
assign da = (B&C)|(A&C);
dff d0(clk, dd, reset, D);
dff2 d1(clk, dc, reset, C);
dff d2(clk, db, reset, B);
dff d3(clk, da, reset, A);
assign q = {A, B, C, D};
endmodule

module dff2(input clk, input d, input reset, output reg q);
always @(posedge clk) begin
    if(reset) q<=1;
    else q<=d;
end
endmodule
