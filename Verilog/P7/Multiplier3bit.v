`include "half_adder.v"
`include "fulladder.v"
module m3bit(input [2:0]A, input [2:0]B, output [5:0]AB);
    wire w1, w2, w3, w4, w5, w6, w7, w8;
    wire s1, s2;
    wire c1, c2, c3, c4, c5, c6;
    and A1(AB[0], A[0], B[0]);
    and A2(w1, A[1], B[0]);
    and A3(w2, A[0], B[1]);
    halfadder HA1(w1, w2, c1, AB[1]);
    and A4(w3, A[2], B[0]);
    and A5(w4, A[1], B[1]);
    fulladder FA1(w3, w4, c1, c2, s1);
    and A6(w5, A[2], B[1]);
    halfadder HA2(w5, c2, c3, s2);
    and A7(w6, A[0], B[2]);
    halfadder HA3(s1, w6, c4, AB[2]);
    and A8(w7, A[1], B[2]);
    fulladder FA2(s2, w7, c4, c5, AB[3]);
    and A9(w8, A[2], B[2]);
    fulladder FA3(w8, c3, c5, c6, AB[4]);
    buf B1(AB[5], c6);
endmodule

//is it possible to make 3bit multiplier using 2bit multiplier? idk i tried its too hard