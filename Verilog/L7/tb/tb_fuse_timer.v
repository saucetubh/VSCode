`timescale 1ns/1ps
`include "src/fuse_timer.v"

module tb_fuse_timer;

    // Inputs
    reg clk;
    reg armed;
    reg hold;

    // Output
    wire [1:0] time_left;

    // Instantiate DUT
    fuse_timer dut (
        .clk(clk),
        .armed(armed),
        .hold(hold),
        .time_left(time_left)
    );
    // Clock generation
    always #5 clk = ~clk;  // 10ns clock period

    initial begin
    $dumpfile("public/vcd/tb_fuse_timer.vcd");
    $dumpvars(0, dut);
        clk   = 0;
        armed = 0;
        hold  = 0;

        $display("\nTesting fuse_timer\n");
        $display("|%-9s|%-5s|%-9s|%-9s|%-9s|", 
                 "Time", "clk", "armed", "hold", "time_left");
        $display("|---------|-----|---------|---------|---------|");
        $monitor("|%-9t|%-5b|%-9b|%-9b|%-9b|", 
                 $time, clk, armed, hold, time_left);

        // --- Test sequence ---

        // Reset state (should reset timer to 11)
        armed = 0; hold = 0; #10;
        armed = 0; hold = 1; #10;

        // Armed, countdown should start
        armed = 1; hold = 0; #10;
        armed = 1; hold = 0; #10;
        armed = 1; hold = 0; #10;

        // Hold active, countdown pauses
        armed = 1; hold = 1; #20;

        // Resume countdown
        armed = 1; hold = 0; #20;

        // Disarm resets back to 11
        armed = 0; hold = 0; #10;

        // Arm again, countdown restart
        armed = 1; hold = 0; #40;

        #10; $monitoroff;
        $finish;
    end
endmodule
