// obstacle_spawner.v
// DECIDES if a new obstacle should be spawned. Does NOT perform the shift.
module obstacle_spawner #(
    parameter WORLD_WIDTH = 16,
    parameter SPAWN_INTERVAL = 8
)(
    input  wire [WORLD_WIDTH-1:0] obstacles_in,
    input  wire [3:0] prev_frame_count,
    input  wire game_active,
    output wire spawn_obstacle, // OUTPUT: A single signal to spawn
    output wire [3:0] frame_count      // OUTPUT: The next frame count
);
    // Create Condition to spawn a new obstacle
    // Only spawn if the game is active
    // Reset frame count on spawn, otherwise increment if active

endmodule
