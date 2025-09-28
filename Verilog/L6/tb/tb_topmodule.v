`include "src/topmodule.v"
module tb_top_module;

    reg clk;
    reg reset;
    reg select_player;
    reg update;

    wire [8:0] scoreA;
    wire [8:0] scoreB;

    top_module dut (
        clk,
        reset,
        select_player,
        update,
        scoreA,
        scoreB
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        $dumpfile("public/vcd/tb_topmodule.vcd");
        $dumpvars(0, tb_top_module);
        $display("\nTesting Top Module\n");
        $display("|%-9s|%-9s|%-9s|%-9s|%-9s|%-9s|%-9s|", "Time", "CLK", "Reset", "Select", "Update", "ScoreA", "ScoreB");
        $display("|---------|---------|---------|---------|---------|---------|---------|");
        $monitor("|%-9d|%-9b|%-9b|%-9b|%-9b|%-9b|%-9b|", 
                 $time, clk, reset, select_player, update, scoreA, scoreB);

        reset = 1; update = 0; select_player = 0; #10;
        reset = 0; #10;

        update = 1; select_player = 0; #10;
        update = 0; select_player = 0; #10;
        update = 1; select_player = 0; #10;
        update = 0; select_player = 0; #10;

        update = 1; select_player = 1; #10;
        update = 0; select_player = 1; #10;
        update = 1; select_player = 1; #10;
        update = 0; select_player = 1; #10;

        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;
        update = 0; select_player = 0; #10;
        update = 0; select_player = 1; #10;

        update = 1; select_player = 0; #10;
        update = 1; select_player = 0; #10;
        update = 0; select_player = 0; #10;
        update = 0; select_player = 0; #10;

        update = 1; select_player = 1; #10;
        update = 1; select_player = 1; #10;
        update = 0; select_player = 1; #10;
        update = 0; select_player = 1; #10;

        reset = 1; #10;
        reset = 0; #10;

        update = 0; select_player = 0; #10;
        update = 0; select_player = 1; #10;
        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;

        update = 0; select_player = 0; #10;
        update = 1; select_player = 0; #10;
        update = 0; select_player = 1; #10;
        update = 1; select_player = 1; #10;

        update = 0; select_player = 0; #10;
        update = 0; select_player = 1; #10;
        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;

        update = 1; select_player = 0; #10;
        update = 0; select_player = 0; #10;
        update = 1; select_player = 1; #10;
        update = 0; select_player = 1; #10;

        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;
        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;

        update = 0; select_player = 0; #10;
        update = 0; select_player = 1; #10;
        update = 0; select_player = 0; #10;
        update = 0; select_player = 1; #10;

        update = 1; select_player = 0; #10;
        update = 1; select_player = 0; #10;
        update = 1; select_player = 0; #10;
        update = 1; select_player = 0; #10;

        update = 1; select_player = 1; #10;
        update = 1; select_player = 1; #10;
        update = 1; select_player = 1; #10;
        update = 1; select_player = 1; #10;

        reset = 1; #10;
        reset = 0; #10;

        update = 0; select_player = 0; #10;
        update = 0; select_player = 1; #10;
        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;

        update = 1; select_player = 0; #10;
        update = 0; select_player = 0; #10;
        update = 1; select_player = 1; #10;
        update = 0; select_player = 1; #10;

        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;
        update = 1; select_player = 0; #10;
        update = 1; select_player = 1; #10;

        update = 0; select_player = 0; #10;
        update = 0; select_player = 1; #10;

        $finish;
    end

endmodule
