`timescale 1ns/1ps
`include "src/priority_encoder_4to2.v"

module tb_priority_encoder_4to2;

    reg [3:0] I;
    reg E;
    wire [1:0] Y;
    wire V;

    priority_encoder_4to2 uut(
        .Y(Y),
        .V(V),
        .I(I),
        .E(E)
    );

    initial begin
        $dumpfile("public/vcd/wave_priority_encoder_4to2.vcd");
        $dumpvars(0, tb_priority_encoder_4to2);

        $display("\nTesting 4:2 Priority Encoder\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|", "Time", "I", "E", "Y", "V");
        $display("|-----|-----|-----|-----|-----|");

        $monitor("|%-5d|%-5b|%-5b|%-5b|%-5b|", 
                 $time, I, E, Y, V);

        // Apply all input cases
            I = 4'b0001; E = 1'b0;
        #10 I = 4'b0010; E = 1'b0;
        #10 I = 4'b0000; E = 1'b1;
        #10 I = 4'b0001; E = 1'b1;
        #10 I = 4'b0010; E = 1'b1;
        #10 I = 4'b0011; E = 1'b1;
        #10 I = 4'b0100; E = 1'b1;
        #10 I = 4'b0101; E = 1'b1;
        #10 I = 4'b0110; E = 1'b0;
        #10 I = 4'b0110; E = 1'b1;
        #10 I = 4'b0111; E = 1'b1;
        #10 I = 4'b1000; E = 1'b1;
        #10 I = 4'b1001; E = 1'b1;
        #10 I = 4'b1010; E = 1'b1;
        #10 I = 4'b1011; E = 1'b1;
        #10 I = 4'b1100; E = 1'b1;
        #10 I = 4'b1101; E = 1'b1;
        #10 I = 4'b1110; E = 1'b1;
        #10 I = 4'b1111; E = 1'b1;

        #10 $finish;
    end
endmodule
