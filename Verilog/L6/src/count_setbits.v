// Top 9-bit counter
// This module should be made Structurally
`include "src/full_adder_4bit.v"

module count_setbits (
    input  [8:0] X,
    output [3:0] count
);
    wire[3:0] s1, s2, s3, s4, s5, s6, s7;
    full_adder_4bit FA1({3'b0,X[0]}, {3'b0,X[1]}, s1);
    full_adder_4bit FA2({3'b0,X[2]}, {3'b0,X[3]}, s2);
    full_adder_4bit FA3({3'b0,X[4]}, {3'b0,X[5]}, s3);
    full_adder_4bit FA4({3'b0,X[6]}, {3'b0,X[7]}, s4);
    full_adder_4bit FA5(s1, s2, s5);
    full_adder_4bit FA6(s3, s4, s6);
    full_adder_4bit FA7(s5, s6, s7);
    full_adder_4bit FA8(s7, {3'b0,X[8]}, count);

endmodule
