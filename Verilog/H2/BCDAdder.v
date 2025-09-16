// Include fullAdder_4bit module
`include "fullAdder_4bit.v"
module BCDAdder(input [3:0] A, input [3:0] B, input Cin, output [3:0] Sum, output Cout);
    // Declare wires -> might have to declare a multibit wire
    wire [3:0] Z, Six; //both wires are 4 bit
    wire c1, c2, c3;
    buf b1(c2, 1'b0);
    //dataflow modelling equivalent would be asign c2 = 1'b0;
    assign Six[0] = 1'b0; //assign Six = 4'b0000;
    assign Six[3] = 1'b0; 
    // WRITE YOUR CODE 
    fullAdder_4bit f41(A, B, Cin, Z, c1);
    assign Cout = c1 | (Z[3] & Z[2]) | (Z[3] & Z[1]);
    assign Six[1] = Cout;
    assign Six[2] = Cout;
    //assign Six = {1'b0, Cout, Cout, 1'b0}; //concatenation operator
    fullAdder_4bit f42(Z, Six, c2, Sum, c3); //no need to put [3:0] for Six and Z as it is already declared as 4 bit wire 
    //fullAdder_4bit f42(Z, Six, 1'b0, Sum, c3); this also works
endmodule

// Follow the circuit diagram and understand how the BCD adder is working
