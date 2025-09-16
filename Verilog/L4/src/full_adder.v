// include your half adder module
// prefix the included module name with "src/"
`include "src/half_adder.v"
module full_adder(
    output sum, carry_out,
    input a, b, carry_in
);
    wire s1, c1, c2;
    half_adder h1(s1, c1, a, b);
    half_adder h2(sum, c2, s1, carry_in);
    or o1(carry_out, c1, c2);

endmodule