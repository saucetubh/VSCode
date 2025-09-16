// include full adder here
`include "fullAdder.v"
module tb_fullAdder;

reg A, B, Cin;
wire Sum, Cout;
// declare inputs as regs and outputs as wires

// instantiate the full adder module
fullAdder f1(.A(A), .B(B), .Cin(Cin), .Sum(Sum), .Cout(Cout));
initial begin
    $dumpfile("tb_fullAdder.vcd");
    $dumpvars(0, tb_fullAdder);
    A = 1'b0; B = 1'b0; Cin = 1'b0;
    #10 A = 1'b0; B = 1'b0; Cin = 1'b1;
    #10 A = 1'b0; B = 1'b1; Cin = 1'b0;
    #10 A = 1'b0; B = 1'b1; Cin = 1'b1;
    #10 A = 1'b1; B = 1'b0; Cin = 1'b0;
    #10 A = 1'b1; B = 1'b0; Cin = 1'b1;
    #10 A = 1'b1; B = 1'b1; Cin = 1'b0;
    #10 A = 1'b1; B = 1'b1; Cin = 1'b1; 
    #10 $finish;
end

initial begin
    $monitor("time = %0d, A = %b, B = %b, Cin = %b, Sum = %b, Cout = %b", $time, A, B, Cin, Sum, Cout);
end

endmodule