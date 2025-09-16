// include your full adder module
// prefix the included module name with "src/"
`include "src/full_adder.v"
module adder_3bit(
    output[2:0] sum,
    output carry,
    input[2:0] a, b
);
    wire c1, c2;
    full_adder f1(sum[0], c1, a[0], b[0], 1'b0);
    full_adder f2(sum[1], c2, a[1], b[1], c1);
    full_adder f3(sum[2], carry, a[2], b[2], c2);

endmodule