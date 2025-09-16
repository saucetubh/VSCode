//idea is to have a 8 bit BCD adder using the 4bit BCD adder made previously
`include "BCDAdder.v"

module BCDAdder2(input [7:0] A, input [7:0] B, input Cin, output [7:0] Sum, output Cout);
    wire [3:0] A1, A2, B1, B2, S1, S2;
    wire c1;
    assign A1 = A[3:0];
    assign A2 = A[7:4];
    assign B1 = B[3:0];
    assign B2 = B[7:4];
    BCDAdder b1(A1, B1, Cin, S1, c1);
    BCDAdder b2(A2, B2, c1, S2, Cout);
    assign Sum = {S2, S1};
endmodule
