// tb_fsm_unzip

`timescale 1ns/1ps
`include "src/fsm_unzip.v"

module tb_fsm_unzip;

    reg clk = 0;
    reg reset;
    reg in;
    wire match;
    wire [3:0] data;

    fsm_unzip DUT (
        .clk(clk),
        .reset(reset),
        .in(in),
        .match(match),
        .data(data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("public/vcd/fsm_unzip.vcd");
        $dumpvars(0, tb_fsm_unzip);

        // Header
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|%-5s|", 
                 "Time", "clk", "reset", "in", "match", "data");
        $display("|-----|-----|-----|-----|-----|-----|");

        reset = 1;
        in    = 0;
        #10;
        reset = 0;           
        $monitor("|%-5d|%-5d|%-5b|%-5b|%-5b|%-5b|", 
                 $time, clk, reset, in, match, data);

        #10 in = 0;
        #10 in = 0; // 7
        #10 in = 1;
        #10 in = 0;
        #10 in = 1; // 0
        #10 in = 0;
        #10 in = 0;
        #10 in = 1; // D
        #10 in = 0;
        #10 in = 1; // 5
        #10 in = 1;
        #10 in = 1; // 2
        #10 in = 1;
        #10 in = 0;
        #10 in = 1; // 0
        #10 in = 1;
        #10 in = 0;
        #10 in = 0; // A
        #10 reset = 1; in = 0;  // Re-assert reset
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;
        #10 in = 0;
        #10;

        $finish;
    end
endmodule