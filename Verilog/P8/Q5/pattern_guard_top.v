`include "../Q2/pattern_next_logic.v"
`include "../Q3/state_register3.v"
`include "../Q4/saturating_counter.v"

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
wire [2:0] next_state;
wire [2:0] hold_mask = {hold_state, hold_state, hold_state};
wire match_now;
wire pre_match;

//assign curr_state = 0; wont do this since i want my current state to have the output of prevoius cycle of inputs stored. With this it would reset to 0 everytime

pattern_next_logic pnl(curr_state, serial_in, next_state, match_now, pre_match); //why does this work, curr_state was declared as output but im using it as input

assign detection_pulse = match_now & (~hold_state);
assign pre_match_flag = pre_match & (~hold_state);
state_register3 sr3(clk, rst_n, 1'b1, hold_mask, (clear_counter | scrub_history), next_state, curr_state);
saturating_counter sc(clk, rst_n, detection_pulse, pre_match_flag & (~match_now), clear_counter, detection_count, detection_maxed);

//assign history_window = {curr_state, serial_in}; dont do this cuz this is continuous assignment, curr_state updates to next_state, might have unexpected behaviour. 

gated_dff gdff1(clk, rst_n, (~freeze_history), scrub_history, serial_in, history_window[0]); //so that the assignment is synced with the clock
gated_dff gdff2(clk, rst_n, (~freeze_history), scrub_history, history_window[0], history_window[1]); //also note that i dont want my history_window to hold the value of my curr_state, since that is affected. by hold state etc.
gated_dff gdff3(clk, rst_n, (~freeze_history), scrub_history, history_window[1], history_window[2]); //history_window should simply hold the log of inputs that are passed
gated_dff gdff4(clk, rst_n, (~freeze_history), scrub_history, history_window[2], history_window[3]);
endmodule