module offside (input A, input B, input C, input D, output P);
wire nB, nC;
wire w1, w2, w3;
not n1(nB, B);
not n2(nC, C);
and a1(w1, A, D);
and a2(w2, nB, D);
and a3(w3, A, nB, nC);
or o1(P, w1, w2, w3);
endmodule