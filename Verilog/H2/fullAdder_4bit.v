// Include fullAdder module
`include "fullAdder.v"

module fullAdder_4bit(input [3:0] A, input [3:0] B, input Cin, output [3:0] Sum, output Cout);

    // Declare wires
    wire c1, c2, c3;
    // Instantiate fullAdder_1bit modules
    fullAdder_1bit fA1(A[0], B[0], Cin, Sum[0], c1);
    fullAdder_1bit fA2(A[1], B[1], c1, Sum[1], c2);
    fullAdder_1bit fA3(A[2], B[2], c2, Sum[2], c3);
    fullAdder_1bit fA4(A[3], B[3], c3, Sum[3], Cout);

endmodule


