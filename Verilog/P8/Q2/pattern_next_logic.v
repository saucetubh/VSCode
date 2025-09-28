module pattern_next_logic (
    input  wire [2:0] curr_state,
    input  wire       serial_in,
    output reg  [2:0] next_state,
    output reg        match_now,
    output reg        pre_match
);
    // Sliding-window next-state logic that simultaneously detects 1101 and 1011.
    reg [3:0] window;

endmodule