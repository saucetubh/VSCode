// include your 2:1 mux module
// prefix the included module name with "src/"
`include "src/mux_2to1.v"
module mux_6to3(
    output[2:0] y,
    input[2:0] in0, in1,
    input sel
);
    mux_2to1 m1(y[0], in0[0], in1[0], sel);
    mux_2to1 m2(y[1], in0[1], in1[1], sel);
    mux_2to1 m3(y[2], in0[2], in1[2], sel);

endmodule


module mux_8to4(
    output[3:0] y,
    input[3:0] in0, in1,
    input sel
);
    mux_2to1 m4(y[0], in0[0], in1[0], sel);
    mux_2to1 m5(y[1], in0[1], in1[1], sel);
    mux_2to1 m6(y[2], in0[2], in1[2], sel);
    mux_2to1 m7(y[3], in0[3], in1[3], sel);

endmodule