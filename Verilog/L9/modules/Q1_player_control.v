// player_control.v
module player_control #(
    parameter MAX_JUMP_HEIGHT = 3,
    parameter GROUND_LEVEL = 0
)(
    input  wire jump_input,
    input  wire [2:0] prev_player_height,
    input  wire [2:0] prev_jump_velocity,
    input  wire game_active,
    output wire [2:0] player_height,
    output wire [2:0] jump_velocity

);

    
endmodule
