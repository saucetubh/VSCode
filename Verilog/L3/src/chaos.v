module chaos (input X4, input X3, input X2, input X1, input X0, output F);
wire NX4, NX3, NX2, NX1, NX0;
wire w1, w2, w3, w4, w5;
not n1(NX4, X4);
not n2(NX3, X3);
not n3(NX2, X2);
not n4(NX1, X1);
not n5(NX0, X0);
and a1(w1, NX4, NX3, NX1);
and a2(w2, NX4, NX2, NX0);
and a3(w3, NX4, NX2, NX1);
and a4(w4, NX3, NX1, NX0);
and a5(w5, NX3, NX2, NX0);
or o1(F, w1, w2, w3, w4, w5);
endmodule