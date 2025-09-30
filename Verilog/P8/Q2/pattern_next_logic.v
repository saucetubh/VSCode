module pattern_next_logic (
    input  wire [2:0] curr_state,
    input  wire       serial_in,
    output reg  [2:0] next_state,
    output reg        match_now,
    output reg        pre_match
);
    // Sliding-window next-state logic that simultaneously detects 1101 and 1011.
    reg [3:0] window;
    always @(*) begin
        window = {curr_state, serial_in};
        match_now = 1'b0;
        pre_match = 1'b0; //these are important to do inside the always block so that after a match is found, it is reset to 0.
        next_state = window[2:0];
        if ((window == 4'b1101) || (window == 4'b1011)) begin
            match_now = 1'b1;
        end
        else if ((curr_state == 3'b110) || (curr_state == 3'b101)) begin
            pre_match = 1'b1;
        end
    end
endmodule