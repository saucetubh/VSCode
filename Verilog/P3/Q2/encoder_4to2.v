module encoder_4to2(input [3:0] A, input E, output [1:0] O);
    buf b1(O[1], E&(A[3]|A[2]));
    buf b2(O[0], E&(A[3]|A[1]));
endmodule

/*
Encoder takes 2^n inputs and gives n outputs. Converts a one hot input to binary output.
A3 A2 A1 A0 O1 O0
0  0  0  1  0  0
0  0  1  0  0  1 
0  1  0  0  1  0 
1  0  0  0  1  1
By noticing the pattern we can say - O1 = A3+A2 and O0 = A3+A1.
Extended truth table 
A3  A2  A1  A0  O1  O0
0   0   0   0   X   X (dont care when no input is given)
0   0   0   1   0   0
0   0   1   0   0   1
0   0   1   1   X   X
0   1   0   0   1   0
0   1   0   1   X   X
0   1   1   0   X   X
0   1   1   1   X   X
1   0   0   0   1   1
1   0   0   1   X   X
1   0   1   0   X   X
1   0   1   1   X   X
1   1   0   0   X   X
1   1   0   1   X   X
1   1   1   0   X   X
1   1   1   1   X   X
Using K maps to solve for O1 and O0 we get 
O1 = 
O0 = 
*/