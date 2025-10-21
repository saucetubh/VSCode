// runner_game_driver.v
// Added default initializers to regs for robustness.
// This is a defensive measure against 'x' propagation.
// PLEASE DO NOT CHANGE THIS MODULE AS IT WILL BREAK YOUR CODE
`include "modules/Q6_runner_game_top.v"

module runner_game_driver;
    // Parameters
    parameter WORLD_WIDTH = 16;

    // Wires and Regs for interconnection
    // Initialize to default values to prevent 'x' states
    reg jump_input            = 0;
    reg [WORLD_WIDTH-1:0] prev_obstacles = 0;
    reg [2:0] prev_player_height = 0;
    reg [2:0] prev_jump_velocity = 0;
    reg prev_game_over        = 0;
    reg [15:0] prev_score     = 0;
    reg [3:0] prev_frame_count  = 0;

    wire [WORLD_WIDTH-1:0] obstacles;
    wire [2:0] player_height;
    wire [2:0] jump_velocity;
    wire collision;
    wire game_over;
    wire [15:0] score;
    wire [3:0] frame_count;

    integer fin, fout, fstate;
    integer scan_result;
    reg [7:0] input_byte;

    // Instantiate the top module
    runner_game_top top_inst (
        .jump_input(jump_input),
        .prev_obstacles(prev_obstacles),
        .prev_player_height(prev_player_height),
        .prev_jump_velocity(prev_jump_velocity),
        .prev_game_over(prev_game_over),
        .prev_score(prev_score),
        .prev_frame_count(prev_frame_count),
        .obstacles(obstacles),
        .player_height(player_height),
        .jump_velocity(jump_velocity),
        .collision(collision),
        .game_over(game_over),
        .score(score),
        .frame_count(frame_count)
    );

    initial begin
        // ===================== READ STATE =====================
        fstate = $fopen("state.txt", "r");
        if (fstate != 0) begin
            scan_result = $fscanf(fstate, "obstacles=%b\n", prev_obstacles);
            scan_result = $fscanf(fstate, "player_height=%d\n", prev_player_height);
            scan_result = $fscanf(fstate, "jump_velocity=%d\n", prev_jump_velocity);
            scan_result = $fscanf(fstate, "game_over=%d\n", prev_game_over);
            scan_result = $fscanf(fstate, "score=%d\n", prev_score);
            scan_result = $fscanf(fstate, "frame_count=%d\n", prev_frame_count);
            $fclose(fstate);
        end else begin
            // Initialize defaults for the very first run
            prev_obstacles = 16'b0001000000000000;
            prev_player_height = 0;
            prev_jump_velocity = 0;
            prev_game_over = 0;
            prev_score = 0;
            prev_frame_count = 0;
        end

        // ===================== READ INPUT =====================
        fin = $fopen("input.txt", "r");
        if (fin != 0) begin
            if ($fscanf(fin, "%d", input_byte) == 1)
                jump_input = input_byte[0];
            else
                jump_input = 0;
            $fclose(fin);
        end else begin
            jump_input = 0;
        end

        // ===================== WRITE OUTPUT =====================
        // Wait one delta for combinational logic to settle
        #1;
        fout = $fopen("output.txt", "w");
        if (fout != 0) begin
            $fdisplay(fout, "obstacles=%b", obstacles);
            $fdisplay(fout, "player_height=%d", player_height);
            $fdisplay(fout, "collision=%d", collision);
            $fdisplay(fout, "game_over=%d", game_over);
            $fdisplay(fout, "score=%d", score);
            $fclose(fout);
        end

        // ===================== SAVE STATE =====================
        fstate = $fopen("state.txt", "w");
        if (fstate != 0) begin
            $fdisplay(fstate, "obstacles=%b", obstacles);
            $fdisplay(fstate, "player_height=%d", player_height);
            $fdisplay(fstate, "jump_velocity=%d", jump_velocity);
            $fdisplay(fstate, "game_over=%d", game_over);
            $fdisplay(fstate, "score=%d", score);
            $fdisplay(fstate, "frame_count=%d", frame_count);
            $fclose(fstate);
        end

        $finish;
    end
endmodule
