// include 2:1 mux here with the correct file path
`include "../mux_2to1.v"
module mux_design(input A, input B, input C, output Z1);
    //WRITE YOUR CODE HERE
    /*
    wire [1:0] In;
    buf B1(In[1], B^C); //or implement this also via mux
    buf B2(In[0], B&C);
    mux_2to1 M211(In, A, Z1);
    */
    wire w1, w2;
    mux_2to1 M211({C, 1'b0}, B, w1);
    mux_2to1 M212({~C, C}, B, w2);
    mux_2to1 M213({w2, w1}, A, Z1);
endmodule

/*
Z1 = ABC' + AB'C + A'BC
A B C | Z1 
0 0 0 |  0 
0 0 1 |  0 
0 1 0 |  0 
0 1 1 |  1 
1 0 0 |  0 
1 0 1 |  1 
1 1 0 |  1     
1 1 1 |  0 

We need to use three 2:1 muxes, hints at usage of multiple select lines
So look at pattern when A and B are my select lines
*/