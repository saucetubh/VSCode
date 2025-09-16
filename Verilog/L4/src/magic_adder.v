// include relevant modules
// prefix the included module names with "src/"
`include "src/gray_to_bin.v"
`include "src/bin_to_gray.v"
`include "src/higher_order_muxes.v"
`include "src/adder_3bit.v"
module magic_adder(
    output[3:0] sum,
    // output carry,
    input[2:0] a, b,
    input is_gray
);
    wire [2:0] a1, b1, t1, t2, t3;
    wire c1;
    gray_to_bin g1(a1, a);
    gray_to_bin g2(b1, b);
    mux_6to3 m61(t1, a, a1, is_gray);
    mux_6to3 m62(t2, b, b1, is_gray);
    adder_3bit a31(t3, c1, t1, t2);
    wire [3:0] s1, s2;
    assign s1 = {c1, t3};
    bin_to_gray b31(s2, s1);
    mux_8to4 m81(sum, s1, s2, is_gray);
endmodule