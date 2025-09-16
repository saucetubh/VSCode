`timescale 1ns/1ps
`include "src/offside.v"

module tb_offside;
    reg a, b, c, d;
    wire p;

    offside o1(.A(a), .B(b), .C(c), .D(d), .P(p));

    initial begin
        $dumpfile("./public/vcd/waveOffside.vcd");
        $dumpvars(0, tb_offside);

        $monitor("%0d X=%b%b%b%b P=%b", $time,a, b, c, d, p);
        {a,b,c,d} = 4'b0000;
        repeat(16) begin
            #5 {a,b,c,d} = {a,b,c,d} + 1;
        end
        #5 $finish;
    end
endmodule
