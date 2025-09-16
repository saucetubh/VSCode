// include BCDAdder module
`include "BCDAdder.v"
module tb_BCDAdder;

// Declare registers (inputs) and wires (outputs)
reg [3:0] A, B;
reg Cin;
wire [3:0] Sum;
wire Cout;

// Instantiate BCDAdder module
BCDAdder b1(A, B, Cin, Sum, Cout);

initial begin
    // create .vcd file
    $dumpfile("tb_BCDAdder.vcd");
    // dump all variables
    $dumpvars(0, tb_BCDAdder);
    A = 4'b0000; B = 4'b0000; Cin = 1'b0;
    #10 A = 4'b0011; B = 4'b0101; Cin = 1'b0;
    #10 A = 4'b0100; B = 4'b0010; Cin = 1'b1;
    #10 A = 4'b1001; B = 4'b1001; Cin = 1'b1;
    #10 A = 4'b0110; B = 4'b0111; Cin = 1'b0;
    #10 A = 4'b0001; B = 4'b0001; Cin = 1'b0;
    #10 A = 4'b0010; B = 4'b0011; Cin = 1'b1;
    #10 A = 4'b0011; B = 4'b0100; Cin = 1'b0;
    #10 A = 4'b0100; B = 4'b0101; Cin = 1'b1;
    #10 A = 4'b0101; B = 4'b0110; Cin = 1'b0;
    #10 $finish;
end
    initial begin
        $monitor("Time = %0d, A = %b, B = %b, Cin = %b, Sum = %b, Cout = %b", $time, A, B, Cin, Sum, Cout);
    end
endmodule
