`include "priority_encoder.v"
module tb;
reg [3:0] A;
reg E;
wire [1:0] O;
wire V;
p_encoder pe(A, E, O, V);
initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    E = 1; A = 4'b0000;
    #10 E=1; A = 4'b0001;
    #10 E=1; A = 4'b0010;
    #10 E=1; A = 4'b0011;
    #10 E=1; A = 4'b0100;
    #10 E=0; A = 4'b0101;
    #10 E=1; A = 4'b0110;
    #10 E=0; A = 4'b0111;
    #10 E=1; A = 4'b1000;
    #10 E=1; A = 4'b1001;
    #10 E=0; A = 4'b1010;
    #10 E=1; A = 4'b1011;
    #10 E=1; A = 4'b1100;
    #10 $finish;
end
initial begin
    $monitor("Time = %0t, E = %b, A = %b, O = %b, V = %b", $time, E, A, O, V);
end
endmodule