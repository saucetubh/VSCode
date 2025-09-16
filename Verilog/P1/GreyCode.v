module GreyCode(input [3:0] B, output [3:0] G, output Y);
    //assign G = {B[3], (B[2]^B[3]), (B[2]^B[1]), (B[1]^B[0])}; dataflow modelling
    //Gate modelling 
    buf b1(G[3], B[3]);
    xor x1(G[2], B[2], B[3]);
    xor x2(G[1], B[2], B[1]);
    xor x3(G[0], B[1], B[0]);
    /*
    wire s, w1, w2, ns;
    and a1(s, B[3], B[0]);
    not n1(ns, s);
    and a2(w1, s, B[2]);
    and a3(w2, ns, B[1]);
    or o1(Y, w1, w2);
    */
    wire s;
    assign s = (B[3] & B[0]);
    assign Y = ((s&B[2]) | (!s&B[1]));
endmodule