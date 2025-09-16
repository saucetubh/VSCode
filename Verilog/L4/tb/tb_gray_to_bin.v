`timescale 1ns/1ps
`include "src/gray_to_bin.v"

module tb_gray_to_bin;
    reg  [2:0] gray;
    wire [2:0] bin;

    gray_to_bin uut (
        .binary(bin),
        .graycode(gray)
    );

    integer i;

    initial begin
        $dumpfile("public/vcd/wave_gray_to_bin.vcd");
        $dumpvars(0, tb_gray_to_bin);

        $display("\nTesting 3-bit Gray to Binary Converter\n");
        $display("|%-5s|%-8s|%-8s|%-8s|%-8s|", "Time", "Gray", "Binary", "Gray(dec)", "Bin(dec)");
        $display("|-----|--------|--------|--------|--------|");

        $monitor("|%-5d|%-8b|%-8b|%-8d|%-8d|", 
                 $time, gray, bin, gray, bin);

        // Apply all possible 3-bit inputs
        for (i = 0; i < 8; i = i + 1) begin
            gray = i[2:0];
            #10;
        end

        #10 $finish;
    end
endmodule
