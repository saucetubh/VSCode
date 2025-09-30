`include "../Q1/gated_dff.v"
module state_register3 (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       load,
    input  wire [2:0] hold_mask,
    input  wire       scrub,
    input  wire [2:0] next_state,
    output wire [2:0] curr_state
);
    gated_dff gdf0(clk, rst_n, (load & (~hold_mask[0])), scrub, next_state[0], curr_state[0]); //either holds the current state or loads the next state
    gated_dff gdf1(clk, rst_n, (load & (~hold_mask[1])), scrub, next_state[1], curr_state[1]);
    gated_dff gdf2(clk, rst_n, (load & (~hold_mask[2])), scrub, next_state[2], curr_state[2]);
endmodule

//allows bits of our choice to be frozen while others can be updated, in a given clock cycle