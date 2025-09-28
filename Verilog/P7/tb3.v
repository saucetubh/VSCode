`include "Multiplier3bit.v"
module tb_multiplier3bit;
    reg [2:0]A;
    reg [2:0]B;
    wire [5:0]AB;
    m3bit M31(A, B, AB);
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb_multiplier3bit);
        A=3'b000; B=3'b000;
        #10 A=3'b010; B=3'b01;
        #10 A=3'b100; B=3'b101;
        #10 A=3'b111; B=3'b111;
        #10 A=3'b100; B=3'b110;
        #10 A=3'b011; B=3'b010;
        #10 A=3'b101; B=3'b111;
        #10 A=3'b110; B=3'b100;
        #10 A=3'b111; B=3'b101;
        #10 $finish;
    end
    initial begin
        $monitor("At time %0d, A = %d, B = %d, AB = %d", $time, A, B, AB);
    end
endmodule