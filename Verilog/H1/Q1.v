module func( input A, B, C, D, output O);
//Method 1
/*
wire nA, nB, nC, nD;
wire w1, w2, w3, w4, w5;

not n1(nA, A);
not n2(nB, B);
not n3(nC, C);
not n4(nD, D);

and a1(w1, nA, nB, nC, nD);
and a2(w2, A, nC, nD);
and a3(w3, nB, C, nD);
and a4(w4, nA, B, C, D);
and a5(w5, B, nC, D);

or o1(O, w1, w2, w3, w4, w5);
*/

wire nA, nB, nD;
wire w1, w2, w3;
not n1(nA, A);
not n2(nB, B);
not n3(nD, D);

and a1(w1, nB, nD);
and a2(w2, nA, B);
and a3(w3, B, D);

or o1(O, w1, w2, w3);
endmodule

// F(0,2,4,5,6,7,8,10,13,15)
// O =  A'B'C'D' + AC'D' + B'CD' + A'BCD + BC'D //this is incorrect expression
// O = B'D' + A'B + BD //simplified using K-maps, verify by simulation
// A -> MSB, D -> LSB