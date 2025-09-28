`timescale 1ns/1ps
`include "pattern_next_logic.v"

module tb_pattern_next_logic;
    reg [2:0] curr_state;
    reg       serial_in;
    wire [2:0] next_state;
    wire       match_now;
    wire       pre_match;

    pattern_next_logic uut (
        .curr_state(curr_state),
        .serial_in(serial_in),
        .next_state(next_state),
        .match_now(match_now),
        .pre_match(pre_match)
    );

    function automatic [4:0] expected(input [2:0] s, input [0:0] b);
        reg [2:0] stable;
        reg [3:0] window;
        reg [2:0] ns;
        reg match;
        reg pre;
        begin
            case (s)
                3'b000,
                3'b001,
                3'b010,
                3'b011,
                3'b100,
                3'b101,
                3'b110,
                3'b111: stable = s;
                default: stable = 3'b000;
            endcase
            window = {stable, b[0]};
            ns = {stable[1:0], b[0]};
            match = (window == 4'b1101) || (window == 4'b1011);
            pre = (window == 4'b1100) || (window == 4'b1010);
            expected = {pre, match, ns};
        end
    endfunction

    integer s, b;
    reg [4:0] exp;
    initial begin
        $dumpfile("tb_pattern_next_logic.vcd");
        $dumpvars(0, tb_pattern_next_logic);

        for (s = 0; s < 8; s = s + 1) begin
            for (b = 0; b < 2; b = b + 1) begin
                curr_state = s[2:0];
                serial_in  = b[0];
                #1;
                exp = expected(curr_state, serial_in);
                if (next_state !== exp[2:0] || match_now !== exp[3] || pre_match !== exp[4]) begin
                    $fatal(1, "Mismatch for state %0b input %0b -> expected next=%0b match=%0b pre=%0b, got next=%0b match=%0b pre=%0b",
                           curr_state, serial_in, exp[2:0], exp[3], exp[4], next_state, match_now, pre_match);
                end
            end
        end

        $display("pattern_next_logic: all transitions verified");
        $finish;
    end
endmodule