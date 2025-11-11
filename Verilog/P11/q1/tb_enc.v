`timescale 1ns/1ps
`include "encryption.v"

module tb_enc;

    reg clk;
    reg set;
    reg in;
    wire [3:0] A;
    wire out;

    // instantiate DUT
    encryption dut (
        .clk(clk),
        .set(set),
        .in(in),
        .A(A),
        .out(out)
    );

    // simple clock toggle
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // input sequence and storage
    reg [7:0] input_seq = 8'b10100111;
    reg [7:0] out_seq;
    integer i;

    initial begin
        $display("t=%0t: Testbench started. Initializing...", $time);
        set = 0;
        in = 0;
        // Assert 'set' to load initial state
        @(posedge clk);
        set <= 1;
        $display("t=%0t: Asserting set to load initial state.", $time);

        @(posedge clk);
        set <= 0;
        $display("t=%0t: De-asserting set.", $time);
        // feed bits LSB first
        $display("time   clk set  in   A    out");
        for (i = 0; i < 8; i = i + 1) begin
            in = input_seq[i];
            #10; // next clock
            out_seq[i] = out;

            $display("%4t   %b   %b   %b   %04b   %b",
                     $time, clk, set, in, A, out);
        end

        $display("Final encrypted output: %b", out_seq);
        #20;
        $finish;
    end

endmodule
