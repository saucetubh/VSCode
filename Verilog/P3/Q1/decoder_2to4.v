module decoder_2to4(input [1:0] A, input E, output [3:0] O);
    assign O[3] = E&A[1]&A[0];
    assign O[2] = E&A[1]&(~A[0]);
    assign O[1] = E&(~A[1])&A[0];
    assign O[0] = E&(~A[1])&(~A[0]);
    //or directly do assign O = {E&A[1]&A[0], E&A[1]&(~A[0]), E&(~A[1])&A[0], E&(~A[1])&(~A[0])};
endmodule

/*
A1  A0  O3 O2 O1 O0
0   0   0  0  0  1   -> minterm m0 corresponding to output O0
0   1   0  0  1  0
1   0   0  1  0  0 
1   1   1  0  0  0
Be careful with the way you define your output acc to the question, here it is assumed you need the output 0001 when input is 00. 
But if that was not the case, then truth table would change for example if you need 1000 when input is 00.
O0 = A1'A0'
O1 = A1'A0
O2 = A1A0'
O3 = A1A0
This is how the truth table for a 2to4 decoder would look, converts binary input to one-hot output. For n innput bits, there are 2^n output bits.
*/ 
