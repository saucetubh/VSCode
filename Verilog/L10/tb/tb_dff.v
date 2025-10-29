
`include "src/dff.v"

module tb_dff;
    reg clk;
    reg d;
    reg reset;
    wire q;

    dff dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("public/vcd/tb_dff.vcd");
        $dumpvars(0, dut);

        clk = 0;
        d = 0;
        reset = 0;

        $display("\nTesting D Flip-Flop\n");
        $display("|%-9s|%-5s|%-6s|%-4s|%-4s|", "Time", "clk", "reset", "d", "q");
        $display("|---------|-----|------|----|----|");

        reset = 1; #10;
        $monitor("|%-9t|%-5b|%-6b|%-4b|%-4b|", $time, clk, reset, d, q);
        reset = 0; #10;
        d = 1; #10;
        d = 0; #10;
        d = 1; #20;
        d = 0; #10;
        reset = 1; #10;
        reset = 0; #10;
        d = 1; #10;
        d = 0; #10;

        $monitoroff;
        $finish;
    end
endmodule
