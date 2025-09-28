`include "Multiplier2bit.v"
module tb_multiplier2bit;
    reg [1:0]A;
    reg [1:0]B;
    wire [3:0]AB;
    m2bit M21(A, B, AB);
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb_multiplier2bit);
        A=2'b00; B=2'b00;
        #10 A=2'b01; B=2'b01;
        #10 A=2'b10; B=2'b10;
        #10 A=2'b11; B=2'b11;
        #10 A=2'b10; B=2'b01;
        #10 A=2'b11; B=2'b10;
        #10 $finish;
    end
    initial begin
        $monitor("At time %0d, A = %d, B = %d, AB = %d", $time, A, B, AB);
    end
endmodule