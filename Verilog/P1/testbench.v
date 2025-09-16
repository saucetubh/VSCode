`include "GreyCode.v"
module tb_GreyCode;
    reg [3:0] B;
    wire [3:0] G;
    wire Y;
    GreyCode g1(B, G, Y);
    initial begin
        $dumpfile("tb_GreyCode.vcd");
        $dumpvars(0, tb_GreyCode);
        B = 4'b0000;
        #10 B = 4'b0001;
        #10 B = 4'b0010;
        #10 B = 4'b0011;
        #10 B = 4'b0100;
        #10 B = 4'b0101;
        #10 B = 4'b0110;
        #10 B = 4'b0111;
        #10 B = 4'b1000;
        #10 B = 4'b1001;
        #10 B = 4'b1010;
        #10 B = 4'b1011;
        #10 B = 4'b1100;
        #10 B = 4'b1101;
        #10 B = 4'b1110;
        #10 B = 4'b1111; 
        #10 $finish;
    end
    initial begin 
        $monitor("Time = %0d, B = %b, G = %b, Y = %b", $time, B, G, Y); //can also use %d instead of %0d
    end
endmodule