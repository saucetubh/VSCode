`timescale 1ns/1ps
`include "modules/Q2_collision_detector.v"

module tb_Q2_collision_detector;

    parameter WIDTH = 16;
    reg [WIDTH-1:0] obstacles;
    reg [2:0] player_height;
    reg prev_game_over;
    reg game_active;
    wire collision;
    wire game_over;

    collision_detector #(
        .WORLD_WIDTH(WIDTH),
        .PLAYER_POSITION(2),
        .GROUND_LEVEL(0)
    ) uut (
        .obstacles(obstacles),
        .player_height(player_height),
        .prev_game_over(prev_game_over),
        .game_active(game_active),
        .collision(collision),
        .game_over(game_over)
    );

    initial begin
        $display("Time(ns) | obstacles | player_h | prev_GO | active | collision | game_over");
        $display("--------------------------------------------------------------------");

        game_active = 1; prev_game_over = 0;

        obstacles = 16'b0000000000000100; player_height = 0; #10;
        $display("%8t | %016b | %8d | %7b | %6b | %9b | %9b", $time, obstacles, player_height, prev_game_over, game_active, collision, game_over);

        // Player above ground - no collision
        obstacles = 16'b0000000000000100; player_height = 1; #10;
        $display("%8t | %016b | %8d | %7b | %6b | %9b | %9b", $time, obstacles, player_height, prev_game_over, game_active, collision, game_over);

        // No obstacle
        obstacles = 16'b0; player_height = 0; #10;
        $display("%8t | %016b | %8d | %7b | %6b | %9b | %9b", $time, obstacles, player_height, prev_game_over, game_active, collision, game_over);

        // Collision persists when prev_game_over = 1
        prev_game_over = 1; obstacles = 16'b0; player_height = 0; #10;
        $display("%8t | %016b | %8d | %7b | %6b | %9b | %9b", $time, obstacles, player_height, prev_game_over, game_active, collision, game_over);

        $finish;
    end
endmodule
