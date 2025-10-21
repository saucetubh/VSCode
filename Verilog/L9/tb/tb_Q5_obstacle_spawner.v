`timescale 1ns/1ps
`include "modules/Q5_obstacle_spawner.v"

module tb_obstacle_spawner;

    parameter WORLD_WIDTH = 16;
    parameter SPAWN_INTERVAL = 8;

    reg [WORLD_WIDTH-1:0] obstacles_in;
    reg [3:0] prev_frame_count;
    reg game_active;

    wire spawn_obstacle;
    wire [3:0] frame_count;

    // Instantiate the spawner
    obstacle_spawner #(
        .WORLD_WIDTH(WORLD_WIDTH),
        .SPAWN_INTERVAL(SPAWN_INTERVAL)
    ) uut (
        .obstacles_in(obstacles_in),
        .prev_frame_count(prev_frame_count),
        .game_active(game_active),
        .spawn_obstacle(spawn_obstacle),
        .frame_count(frame_count)
    );

    // Expected values
    reg expected_spawn;
    reg [3:0] expected_frame;

    initial begin
        $display("Time | active | obstacles           | prev_count | spawn_obstacle | frame_count | Correct/Wrong");
        $display("---------------------------------------------------------------------------------------------");

        // Case 1: Game active, interval not reached
        obstacles_in = 16'b0000000000000000; prev_frame_count = 5; game_active = 1; #10;
        expected_spawn = 0;
        expected_frame = prev_frame_count + 1;
        $display("%4t | %b      | %b | %d          | %b             | %d          | %s",
                 $time, game_active, obstacles_in, prev_frame_count, spawn_obstacle, frame_count,
                 ((spawn_obstacle===expected_spawn)&&(frame_count===expected_frame))?"Correct":"Wrong");

        // Case 2: Game active, interval reached, last two empty
        obstacles_in = 16'b0000000000000000; prev_frame_count = SPAWN_INTERVAL; game_active = 1; #10;
        expected_spawn = 1;
        expected_frame = 0;
        $display("%4t | %b      | %b | %d          | %b             | %d          | %s",
                 $time, game_active, obstacles_in, prev_frame_count, spawn_obstacle, frame_count,
                 ((spawn_obstacle===expected_spawn)&&(frame_count===expected_frame))?"Correct":"Wrong");

        // Case 3: Game active, interval reached, last two blocked
        obstacles_in = 16'b1100000000000000; prev_frame_count = SPAWN_INTERVAL; game_active = 1; #10;
        expected_spawn = 0;
        expected_frame = prev_frame_count + 1;
        $display("%4t | %b      | %b | %d          | %b             | %d          | %s",
                 $time, game_active, obstacles_in, prev_frame_count, spawn_obstacle, frame_count,
                 ((spawn_obstacle===expected_spawn)&&(frame_count===expected_frame))?"Correct":"Wrong");

        // Case 4: Game inactive
        obstacles_in = 16'b0000000000000000; prev_frame_count = 8; game_active = 0; #10;
        expected_spawn = 0;
        expected_frame = prev_frame_count;
        $display("%4t | %b      | %b | %d          | %b             | %d          | %s",
                 $time, game_active, obstacles_in, prev_frame_count, spawn_obstacle, frame_count,
                 ((spawn_obstacle===expected_spawn)&&(frame_count===expected_frame))?"Correct":"Wrong");

        // Case 5: Game active, interval 0, last two empty
        obstacles_in = 16'b0000000000000000; prev_frame_count = 0; game_active = 1; #10;
        expected_spawn = 0;
        expected_frame = 1;
        $display("%4t | %b      | %b | %d          | %b             | %d          | %s",
                 $time, game_active, obstacles_in, prev_frame_count, spawn_obstacle, frame_count,
                 ((spawn_obstacle===expected_spawn)&&(frame_count===expected_frame))?"Correct":"Wrong");

        // Case 6: Game active, interval reached, last two partially blocked
        obstacles_in = 16'b0100000000000000; prev_frame_count = SPAWN_INTERVAL; game_active = 1; #10;
        expected_spawn = 0;
        expected_frame = prev_frame_count + 1;
        $display("%4t | %b      | %b | %d          | %b             | %d          | %s",
                 $time, game_active, obstacles_in, prev_frame_count, spawn_obstacle, frame_count,
                 ((spawn_obstacle===expected_spawn)&&(frame_count===expected_frame))?"Correct":"Wrong");

        $finish;
    end

endmodule
