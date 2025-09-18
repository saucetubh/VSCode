`timescale 1ns/1ps
`include "src/decoder_2to4.v"

module tb_decoder_2to4;

    reg [1:0] A;
    reg E;
    wire [3:0] D;

    decoder_2to4 uut(
        .D(D),
        .A(A),
        .E(E)
    );

    initial begin
        $dumpfile("public/vcd/wave_decoder_2to4.vcd");
        $dumpvars(0, tb_decoder_2to4);

        $display("\nTesting 2:4 Decoder\n");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "A", "E", "D");
        $display("|-----|-----|-----|-----|");

        $monitor("|%-5d|%-5b|%-5b|%-5b|", 
                 $time, A, E, D);

        // Apply all input cases
            A = 2'b01; E = 1'b0;
        #10 A = 2'b10; E = 1'b0;
        #10 A = 2'b00; E = 1'b1;
        #10 A = 2'b01; E = 1'b1;
        #10 A = 2'b10; E = 1'b1;
        #10 A = 2'b10; E = 1'b0;
        #10 A = 2'b11; E = 1'b1;

        #10 $finish;
    end
endmodule
