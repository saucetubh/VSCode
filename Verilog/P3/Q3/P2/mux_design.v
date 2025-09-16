// include 2:1 mux here with the correct file path
`include "../mux_2to1.v"
module mux_design(input A, input B, input C, output Z2);
    //WRITE YOUR CODE HERE
    wire w1, w2;
    mux_2to1 M211({C, 1'b0}, B, w1);
    mux_2to1 M212({1'b1, C}, B, w2);
    mux_2to1 M213({w2, w1}, A, Z2);
endmodule
/*
Z2 = AB + AC + BC
A B C | Z2
0 0 0 | 0
0 0 1 | 0
0 1 0 | 0
0 1 1 | 1
1 0 0 | 0
1 0 1 | 1
1 1 0 | 1 
1 1 1 | 1
*/