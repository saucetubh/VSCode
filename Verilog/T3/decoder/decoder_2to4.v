module decoder_2to4(input [1:0]A, output [3:0]D); //only one output is high at a time
    wire na1, na2;
    not n1(na1, A[0]);
    not n2(na2, A[1]);
    and a1(D[0], na1, na2);
    and a2(D[1], A[0], na2);
    and a3(D[2], na1, A[1]);
    and a4(D[3], A[0], A[1]);

    /*dataflow modeling
    assign D[0] = ~A[0] & ~A[1];
    assign D[1] = ~A[0] & A[1];
    assign D[2] = A[0] & ~A[1];
    assign D[3] = A[0] & A[1];


    A[1] A[0]  D[3] D[2] D[1] D[0]
    0     0     0    0    0    1
    0     1     0    0    1    0
    1     0     0    1    0    0
    1     1     1    0    0    0

    hint: minterms 
    */


endmodule

//refer to slides 