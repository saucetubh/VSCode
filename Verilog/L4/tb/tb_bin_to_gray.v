`timescale 1ns/1ps
`include "src/bin_to_gray.v"

module tb_bin_to_gray;
    reg  [3:0] bin;
    wire [3:0] gray;

    bin_to_gray uut (
        .graycode(gray),
        .binary(bin)
    );

    integer i;

    initial begin
        $dumpfile("public/vcd/wave_bin_to_gray.vcd");
        $dumpvars(0, tb_bin_to_gray);

        $display("\nTesting 4-bit Binary to Gray Converter\n");
        $display("|%-5s|%-8s|%-8s|%-8s|", "Time", "Decimal", "Binary", "Gray");
        $display("|-----|--------|--------|--------|");

        $monitor("|%-5d|%-8d|%-8b|%-8b|", 
                 $time, bin, bin, gray);

        // Apply all possible 4-bit inputs
        for (i = 0; i < 16; i = i + 1) begin
            bin = i[3:0];
            #10;
        end

        #10 $finish;
    end
endmodule
