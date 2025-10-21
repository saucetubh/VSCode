`timescale 1ns/1ps
`include "modules/Q1_player_control.v"

module tb_player_control;

    reg jump_input;
    reg [2:0] prev_player_height;
    reg [2:0] prev_jump_velocity;
    reg game_active;
    wire [2:0] player_height;
    wire [2:0] jump_velocity;

    player_control uut (
        .jump_input(jump_input),
        .prev_player_height(prev_player_height),
        .prev_jump_velocity(prev_jump_velocity),
        .game_active(game_active),
        .player_height(player_height),
        .jump_velocity(jump_velocity)
    );

    integer i;

    initial begin
        $display("Time(ns) | jump_in | prev_h | prev_v | active | next_h | next_v");
        $display("---------------------------------------------------------------");

        // Initialize
        game_active = 1;
        prev_player_height = 0;
        prev_jump_velocity = 0;

        // Frame 0: Jump from ground
        jump_input = 1; #10;
        $display("%8t | %7b | %6d | %6d | %6b | %6d | %6d", 
                 $time, jump_input, prev_player_height, prev_jump_velocity, game_active, player_height, jump_velocity);

        // Simulate several frames
        for (i = 0; i < 6; i = i + 1) begin
            // Feed outputs back as inputs
            prev_player_height = player_height;
            prev_jump_velocity = jump_velocity;
            jump_input = (i == 3) ? 1 : 0; // try pressing jump mid-air at frame 3
            #10;
            $display("%8t | %7b | %6d | %6d | %6b | %6d | %6d", 
                     $time, jump_input, prev_player_height, prev_jump_velocity, game_active, player_height, jump_velocity);
        end

        // Test falling to ground
        jump_input = 0;
        prev_jump_velocity = 0;
        prev_player_height = 2; #10;
        $display("%8t | %7b | %6d | %6d | %6b | %6d | %6d", 
                 $time, jump_input, prev_player_height, prev_jump_velocity, game_active, player_height, jump_velocity);

        // Test freeze when game inactive
        game_active = 0; prev_player_height = player_height; prev_jump_velocity = jump_velocity; jump_input = 1; #10;
        $display("%8t | %7b | %6d | %6d | %6b | %6d | %6d", 
                 $time, jump_input, prev_player_height, prev_jump_velocity, game_active, player_height, jump_velocity);

        $finish;
    end
endmodule
