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
    wire c1; //condition for increment in score
    assign c1 = (game_active)&(obstacles[0]==1);
    assign score = c1 ? (prev_score + POINTS_PER_OBSTACLE) : prev_score;
endmodule
