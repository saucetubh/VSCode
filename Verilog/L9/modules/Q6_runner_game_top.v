// runner_game_top.v
//include all 5 modules
`include "modules/Q1_player_control.v"
`include "modules/Q5_obstacle_spawner.v"
`include "modules/Q2_collision_detector.v"
`include "modules/Q3_score_counter.v"
`include "modules/Q4_universal_shift_register.v"

module runner_game_top #(
    parameter WORLD_WIDTH = 16,
    parameter MAX_JUMP_HEIGHT = 3,
    parameter GROUND_LEVEL = 0,
    parameter PLAYER_POSITION = 2,
    parameter POINTS_PER_OBSTACLE = 10,
    parameter SPAWN_INTERVAL = 8
)(
    input  wire jump_input,
    input  wire [WORLD_WIDTH-1:0] prev_obstacles,
    input  wire [2:0]  prev_player_height,
    input  wire [2:0]  prev_jump_velocity,
    input  wire        prev_game_over,
    input  wire [15:0] prev_score,
    input  wire [3:0]  prev_frame_count,

    output wire [WORLD_WIDTH-1:0] obstacles,
    output wire [2:0]  player_height,
    output wire [2:0]  jump_velocity,
    output wire        collision,
    output wire        game_over,
    output wire [15:0] score,
    output wire [3:0]  frame_count
);
    // To pass parameters, use the following syntax

    // player_control #(
    //     .MAX_JUMP_HEIGHT(MAX_JUMP_HEIGHT),
    //     .GROUND_LEVEL(GROUND_LEVEL)
    // ) player_control (


    // Use this for Game active flag
    wire game_active = ~prev_game_over;

    // Begin coding here by declaing Intermediate wires
    
    // -------------------------
    // 1. Player Control
    // -------------------------
    player_control #(
        .MAX_JUMP_HEIGHT(MAX_JUMP_HEIGHT),
        .GROUND_LEVEL(GROUND_LEVEL)
    ) player_control (
        .jump_input(jump_input),
        .prev_player_height(prev_player_height),
        .prev_jump_velocity(prev_jump_velocity),
        .game_active(game_active),
        .player_height(player_height),
        .jump_velocity(jump_velocity)
    );
    // -------------------------
    // 2. Decide if an obstacle should spawn
    // -------------------------
    wire spawn_obstacle;
    obstacle_spawner #(
        .WORLD_WIDTH(WORLD_WIDTH),
        .SPAWN_INTERVAL(SPAWN_INTERVAL)
    ) obstacle_spawner (
        .obstacles_in(prev_obstacles),
        .prev_frame_count(prev_frame_count),
        .game_active(game_active),
        .spawn_obstacle(spawn_obstacle),
        .frame_count(frame_count)
    );

    // -------------------------
    // 3. Shift Obstacles and inject a new one if needed
    // -------------------------
    universal_shift_register #(
        .WIDTH(WORLD_WIDTH)
    ) obstacle_shift_register (
        .data_in(prev_obstacles),
        .parallel_in(prev_obstacles), //doesnt matter since mode will never be parallel load
        .serial_in_left(spawn_obstacle),
        .serial_in_right(1'b0), // New obstacle enters from left
        .mode(game_active ? 2'b01 : 2'b00), // Shift Right, mentioned in question
        .data_out(obstacles)
    );




    // -------------------------
    // 4. Collision Detection
    // -------------------------
    collision_detector #(
        .WORLD_WIDTH(WORLD_WIDTH),
        .PLAYER_POSITION(PLAYER_POSITION),
        .GROUND_LEVEL(GROUND_LEVEL)
    ) collision_detector (
        .obstacles(obstacles),
        .player_height(player_height),
        .prev_game_over(prev_game_over),
        .game_active(game_active),
        .collision(collision),
        .game_over(game_over)
    );

    // -------------------------
    // 5. Score Counter
    // -------------------------
    score_counter #(
        .WORLD_WIDTH(WORLD_WIDTH),
        .POINTS_PER_OBSTACLE(POINTS_PER_OBSTACLE)
    ) score_counter (
        .obstacles(obstacles),
        .prev_score(prev_score),
        .game_active(game_active),
        .score(score)
    );
    // -------------------------
    // Finalize outputs if any
    // -------------------------
    

endmodule
