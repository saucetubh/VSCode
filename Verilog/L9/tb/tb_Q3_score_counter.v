`timescale 1ns/1ps
`include "modules/Q3_score_counter.v"

module tb_Q3_score_counter;

    parameter WIDTH = 16;
    reg [WIDTH-1:0] obstacles;
    reg [15:0] prev_score;
    reg game_active;
    wire [15:0] score;

    score_counter #(
        .WORLD_WIDTH(WIDTH),
        .POINTS_PER_OBSTACLE(10)
    ) uut (
        .obstacles(obstacles),
        .prev_score(prev_score),
        .game_active(game_active),
        .score(score)
    );

    initial begin
        $display("Time(ns) | obstacles | prev_score | active | next_score");
        $display("---------------------------------------------------------");

        game_active = 1; prev_score = 0;

        obstacles = 16'b1; #10;
        $display("%8t | %016b | %10d | %6b | %10d", $time, obstacles, prev_score, game_active, score);

        obstacles = 16'b0; prev_score = score; #10;
        $display("%8t | %016b | %10d | %6b | %10d", $time, obstacles, prev_score, game_active, score);

        // Inactive game
        game_active = 0; obstacles = 16'b1; prev_score = score; #10;
        $display("%8t | %016b | %10d | %6b | %10d", $time, obstacles, prev_score, game_active, score);

        $finish;
    end
endmodule
