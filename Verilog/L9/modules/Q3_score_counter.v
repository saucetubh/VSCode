// Computes next score
module score_counter #(
    parameter WORLD_WIDTH = 16,
    parameter POINTS_PER_OBSTACLE = 10
)(
    input  wire [WORLD_WIDTH-1:0] obstacles,
    input  wire [15:0] prev_score,
    input  wire game_active,        
    output wire [15:0] score
);

    // Only count score if the game is active
    

endmodule
