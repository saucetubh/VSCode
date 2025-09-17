`include "comparator.v"
module tb;
reg [3:0] A;
reg [3:0] B;
wire Oeq, Ogt, Olt;
isequal_4bit IE(A, B, Oeq);
isgreater IG(A, B, Ogt);
islesser IL(A, B, Olt);
initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    A = 4'b0000; B = 4'b0000;
    #10 A = 4'b0001; B = 4'b0010;
    #10 A = 4'b0010; B = 4'b0001;
    #10 A = 4'b0011; B = 4'b0011;
    #10 A = 4'b0100; B = 4'b0101;
    #10 A = 4'b0101; B = 4'b0100;
    #10 A = 4'b0110; B = 4'b0110;
    #10 A = 4'b0111; B = 4'b1000;
    #10 A = 4'b1000; B = 4'b0111;
    #10 A = 4'b1001; B = 4'b1001;
    #10 A = 4'b1010; B = 4'b1011;
    #10 A = 4'b1011; B = 4'b1010;
    #10 A = 4'b0100; B = 4'b1000;
    #10 $finish;
end
initial begin 
    $monitor("At time %0d, A = %b, B = %b, A==B: %b, A>B: %b, A<B: %b", $time, A, B, Oeq, Ogt, Olt);
end
endmodule