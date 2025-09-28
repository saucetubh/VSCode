`timescale 1ns/1ps
`include "direction_fsm.v"

module direction_fsm_tb;
    reg clk;
    reg reset_n;
    reg turn_right;
    wire [1:0] direction;
    reg [39:0] direction_name;

    direction_fsm dut (
        .clk(clk),
        .reset_n(reset_n),
        .turn_right(turn_right),
        .direction(direction)
    );

    // 100 MHz clock
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Track a printable version of the direction for waveform logging.
    always @(*) begin
        case (direction)
            2'b00: direction_name = "NORTH";
            2'b01: direction_name = "EAST ";
            2'b10: direction_name = "SOUTH";
            2'b11: direction_name = "WEST ";
            default: direction_name = "?????";
        endcase
    end

    initial begin
        $display("  Time | reset | turn_right | direction");
    end

    always @(posedge clk) begin
        $display("%6t |   %b   |      %b      | %s", $time, reset_n, turn_right, direction_name);
    end

    initial begin
        reset_n = 1'b0;
        turn_right = 1'b0;
        #12;
        reset_n = 1'b1;

        // Rotate clockwise through all directions
        repeat (4) begin
            @(negedge clk);
            turn_right = 1'b1;
        end

        // Rotate counter-clockwise back to north
        repeat (4) begin
            @(negedge clk);
            turn_right = 1'b0;
        end

        // Alternate turns to validate branching
        @(negedge clk) turn_right = 1'b1;
        @(negedge clk) turn_right = 1'b0;
        @(negedge clk) turn_right = 1'b1;
        @(negedge clk) turn_right = 1'b0;

        #20;
        $finish;
    end
endmodule
