// include 2:4 decoder here
`include "decoder_2to4.v"
module decoder_3to8(input [2:0] A, input E, output [7:0] O);
    //WRITE YOUR CODE HERE
    decoder_2to4 d1(A[1:0], E&(~A[2]), O[3:0]);
    decoder_2to4 d2(A[1:0], E&(A[2]), O[7:4]);
endmodule
/*
A2  A1  A0  O7 O6 O5 O4 O3 O2 O1 O0
0   0   0   0  0  0  0  0  0  0  1
0   0   1   0  0  0  0  0  0  1  0
0   1   0   0  0  0  0  0  1  0  0
0   1   1   0  0  0  0  1  0  0  0
1   0   0   0  0  0  1  0  0  0  0
1   0   1   0  0  1  0  0  0  0  0
1   1   0   0  1  0  0  0  0  0  0
1   1   1   1  0  0  0  0  0  0  0
To implement this, we can use something like an enabler to decide which 2to4 decoder to use. 
A2 acts like an enabler for the 2to4 decoders. If A2 is 0, we use the first 4to2 decoder, else we use the second one. 
*/