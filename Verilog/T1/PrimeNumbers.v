//F(2,3,5,7,11,13,17,19,23,29,31)

module primes( input A, B, C, D, E, output Y );

    // Declare wires
    wire w1, w2, w3, w4, w5, w6;
    wire nA, nB, nC, nD, nE;
    // Use NOT gates to negate inputs
    not g1(nA, A);
    not g2(nB, B);
    not g3(nC, C);
    not g4(nD, D);
    not g5(nE, E);

    // A'C'DE
    and a1(w1, nA, nC, D, E);
    // ABCE
    and a2(w2, A, B, C, E);
    // AB'C'E
    and a3(w3, A, nB, nC, E);
    // B'DE
    and a4(w4, nB, D, E);
    // A'CD'E
    and a5(w5, nA, C, nD, E);
    // A'B'C'D
    and a6(w6, nA, nB, nC, D);

    // Store output
    or o1(Y, w1, w2, w3, w4, w5, w6);

endmodule