// include 3:8 decoder here
`include "decoder_3to8.v"
module fullAdder(input A, input B, input Cin, output Sum, output Cout);
    //WRITE YOUR CODE HERE
    //wire [2:0]C;
    wire [7:0]O;
    //assign C = {A, B, Cin};
    decoder_3to8 d1({A, B, Cin}, 1'b1, O); //can simply do this
    //assign Sum = O[1] | O[2] | O[4] | O[7];
    //assign Cout = O[3] | O[5] | O[6] | O[7];
    or o1(Sum, O[1], O[2], O[4], O[7]);
    or o2(Cout, O[3], O[5], O[6], O[7]);
    //this is how the question wants us to implement it, using two or gates
endmodule 


/*
Truth table for full adder -
A B Cin Sum Cout
0 0  0   0   0  
0 0  1   1   0  
0 1  0   1   0  
0 1  1   0   1  
1 0  0   1   0  
1 0  1   0   1  
1 1  0   0   1  
1 1  1   1   1  
Our 3to8 decoder is essentially taking inputs and outputs minterms and stores in the vector. We can use these minterms to implement the full adder logic.
Since Sum and Cout can be expressed as a sum of minterms. 
*/