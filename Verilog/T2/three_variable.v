// A'C + A'B + AB'C + BC = C + A'B

module three_variable (input a, input b, input c, output out);

// gate-level model

/* 
wire a_bar;
wire a_bar_b;

not n0 (a_bar, a);
and a0 (a_bar_b, a_bar, b);
or o0 (out, c, a_bar_b);
*/

// dataflow model
// assign out = (~a & c) | (~a & b) | (a & ~b & c) | (b & c);
assign out = c | (~a & b);

endmodule