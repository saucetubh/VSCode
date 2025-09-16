// Include halfAdder module -> Use the file name while including, not the module name
`include "halfAdder.v"

module fullAdder_1bit(input A, input B, input Cin, output Sum, output Cout);

    // Declare wires
    wire c1, s1, c2;

    // Instantiate halfAdder modules -> Remember to use the module name and not the file name
    halfAdder_1bit hA1(A, B, s1, c1);
    halfAdder_1bit hA2(s1, Cin, Sum, c2);
    or o1(Cout, c1, c2);
    // OR directly use formula for Sum and Cout
    // assign Sum = (A ^ B) ^ Cin
    // assign Cout = (A & B) | (B & Cin) | (A & Cin)
/*
Rough work 
A B Cin Sum Cout s1 c1 Sum c2 
0 0  0   0   0   0  0   0  0
0 0  1   1   0   0  0   1  0
0 1  0   1   0   1  0   1  0
0 1  1   0   1   1  0   0  1
1 0  0   1   0   1  0   1  0
1 0  1   0   1   1  0   0  1
1 1  0   0   1   0  1   0  0
1 1  1   1   1   0  1   1  0
*/
endmodule



