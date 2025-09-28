`include "../Q2/pattern_next_logic.v"
`include "../Q3/state_register3.v"
`include "../Q4/saturating_counter.v"
`include "../Q1/gated_dff.v"

module pattern_guard_top (
    input  wire clk,
    input  wire rst_n,
    input  wire serial_in,
    input  wire hold_state,
    input  wire freeze_history,
    input  wire clear_counter,
    input  wire scrub_history,
    output wire [2:0] curr_state,
    output wire       detection_pulse,
    output wire [1:0] detection_count,
    output wire       detection_maxed,
    output wire [3:0] history_window,
    output wire       pre_match_flag
);

endmodule