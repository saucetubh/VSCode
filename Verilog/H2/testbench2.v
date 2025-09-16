`include "BCDAdder2.v"
module tb_BCDAdder2;
    reg [7:0] A, B;
    reg Cin;
    wire [7:0] Sum;
    wire Cout;
    BCDAdder2 b1(A, B, Cin, Sum, Cout);
    initial begin
        $dumpfile("tb_BCDAdder2.vcd");
        $dumpvars(0, tb_BCDAdder2);
        A = 8'b00000000; B = 8'b00000000; Cin = 0;
        #10 A = 8'b00000001; B = 8'b00010110; Cin = 0;
        #10 A = 8'b01100010; B = 8'b10011000; Cin = 0;
        #10 A = 8'b00010111; B = 8'b00100100; Cin = 1;
        #10 A = 8'b10011001; B = 8'b10011001; Cin = 0;
        #10 A = 8'b10011001; B = 8'b10011001; Cin = 1;
        #10 A = 8'b01001001; B = 8'b01001001; Cin = 1;
        #10 $finish;
    end
    initial begin
        $monitor("Time = %0d, A = %b, B = %b, Cin = %b, Sum = %b, Cout = %b", $time, A, B, Cin, Sum, Cout);
    end
endmodule