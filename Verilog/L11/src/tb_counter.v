`timescale 1ns/1ps
`include "counter.v"
module tb_top;

    reg clk = 0;
    reg clr = 0;
    wire [1:0] O;

    // instantiate top
    top uut (
        .clk(clk),
        .clr(clr),
        .O(O)
    );

    // 10 ns clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);

        // apply clear
        clr = 1;
        #20;
        clr = 0;

        // run for some cycles
        repeat (20) begin
            @(negedge clk);
            #6; // allow ripple to settle
            $display("@%0t  O = %b", $time, O);
        end

        $finish;
    end

endmodule