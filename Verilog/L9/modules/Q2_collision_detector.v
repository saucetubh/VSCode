// Detects collision at player position
module collision_detector #(
    parameter WORLD_WIDTH = 16,
    parameter PLAYER_POSITION = 2,
    parameter GROUND_LEVEL = 0
)(
    input  wire [WORLD_WIDTH-1:0] obstacles,
    input  wire [2:0] player_height,
    input  wire prev_game_over,
    input  wire game_active,
    output wire collision,
    output wire game_over
);

    wire c1; //condition for collision
    assign c1 = (game_active)&(obstacles[PLAYER_POSITION] == 1)&(player_height == GROUND_LEVEL);
    assign collision = c1 ? 1'b1 : 1'b0;
    assign game_over = collision ? 1'b1 : prev_game_over; //is this taking care of the latch condition?
    

endmodule
