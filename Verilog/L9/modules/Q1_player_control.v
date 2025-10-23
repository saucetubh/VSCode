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
    wire c1, c2, c3;
    assign c1 = game_active&(jump_input)&(prev_player_height == GROUND_LEVEL)&(prev_jump_velocity == 0); //condition for just jumping
    assign c2 = game_active&(prev_jump_velocity > 0); //condition for decreasing jump velocity and increasing height
    assign c3 = game_active&(prev_jump_velocity == 0)&(prev_player_height > GROUND_LEVEL); //condition for falling

    assign jump_velocity = c1 ? MAX_JUMP_HEIGHT :
                           c2 ? prev_jump_velocity - 1 :
                           prev_jump_velocity; //default case, i.e when c1 and c2 are false (is this correct?)
    assign player_height = c2 ? prev_player_height + 1 :
                           c3 ? prev_player_height - 1 :
                           prev_player_height; //default case, i.e when c2 and c3 are false (is this correct? - yes, mentioned in the question)
endmodule