`include "Mux.v"
module tb_mux;
    reg [3:0] A, B;
    reg s;
    wire [3:0] Y;
    mux m1(A, B, s, Y);
    initial begin 
        $dumpfile("tb_mux.vcd");
        $dumpvars(0, tb_mux);
        A=4'b0110; B=4'b0101; s=1'b0;
        #10 A=4'b0110; B=4'b0101; s=1'b1;
        #10 $finish;
    end
    initial begin
        $monitor("Time = %0d, A = %b, B = %b, s = %b, Y = %b", $time, A, B, s, Y);
    end
endmodule