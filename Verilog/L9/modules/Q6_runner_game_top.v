// runner_game_top.v
//include all 5 modules

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
    // ) player_ctrl (


    // Use this for Game active flag
    wire game_active = ~prev_game_over;

    // Begin coding here by declaing Intermediate wires

    // -------------------------
    // 1. Player Control
    // -------------------------
    
    // -------------------------
    // 2. Decide if an obstacle should spawn
    // -------------------------
    

    // -------------------------
    // 3. Shift Obstacles and inject a new one if needed
    // -------------------------




    // -------------------------
    // 4. Collision Detection
    // -------------------------
    

    // -------------------------
    // 5. Score Counter
    // -------------------------
    
    // -------------------------
    // Finalize outputs if any
    // -------------------------
    

endmodule
