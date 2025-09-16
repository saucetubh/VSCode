`timescale 1ns/1ps
`include "src/chaos.v"

module tb;
    reg X4, X3, X2, X1, X0;
    wire F;

    chaos c1(.X4(X4), .X3(X3), .X2(X2), .X1(X1), .X0(X0), .F(F));

    initial begin
        $dumpfile("./public/vcd/waveChaos.vcd");
        $dumpvars(0, tb);

        $monitor("%0d X=%b%b%b%b%b F=%b", $time, X4, X3, X2, X1, X0, F);
        X4=0; X3=0; X2=0; X1=0; X0=0;
        repeat(32) begin
            #5 {X4,X3,X2,X1,X0} = {X4,X3,X2,X1,X0} + 1;
        end
        #5 $finish;
    end
endmodule
