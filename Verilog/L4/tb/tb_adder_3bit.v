`timescale 1ns/1ps
`include "src/adder_3bit.v"

module tb_adder_3bit;
    reg  [2:0] a, b;
    wire [2:0] sum;
    wire       carry;

    adder_3bit uut (
        .sum(sum),
        .carry(carry),
        .a(a),
        .b(b)
    );

    integer i, j;

    initial begin
        $dumpfile("public/vcd/wave_adder_3bit.vcd");
        $dumpvars(0, tb_adder_3bit);

        $display("\nTesting 3-bit Adder\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|", "Time", "a", "b", "sum", "carry",);
        $display("|-----|-----|-----|-----|-----|");

        $monitor("|%-5d|%-5b|%-5b|%-5b|%-5b|", 
                 $time, a, b, sum, carry);

        // Exhaustively test all input combinations
        for (i = 0; i < 8; i = i + 1) begin
            for (j = 0; j < 8; j = j + 1) begin
                a = i[2:0];
                b = j[2:0];
                #10;
            end
        end

        #10 $finish;
    end
endmodule
