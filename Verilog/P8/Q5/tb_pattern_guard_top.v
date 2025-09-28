`timescale 1ns/1ps
`include "pattern_guard_top.v"

module tb_pattern_guard_top;
    reg clk;
    reg rst_n;
    reg serial_in;
    reg hold_state;
    reg freeze_history;
    reg clear_counter;
    reg scrub_history;
    wire [2:0] curr_state;
    wire detection_pulse;
    wire [1:0] detection_count;
    wire detection_maxed;
    wire [3:0] history_window;
    wire pre_match_flag;

    pattern_guard_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_in(serial_in),
        .hold_state(hold_state),
        .freeze_history(freeze_history),
        .clear_counter(clear_counter),
        .scrub_history(scrub_history),
        .curr_state(curr_state),
        .detection_pulse(detection_pulse),
        .detection_count(detection_count),
        .detection_maxed(detection_maxed),
        .history_window(history_window),
        .pre_match_flag(pre_match_flag)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    reg [2:0] expected_state;
    reg [3:0] expected_history;
    reg [1:0] expected_count;
    reg expected_maxed;
    reg expected_pulse_now;
    reg expected_pre_flag_now;
    reg [2:0] next_state_calc;
    reg match_prev;
    reg pre_prev;
    reg inc_double_prev;

    integer round;
    integer ctrl;
    integer bit_in;

    initial begin
        $dumpfile("tb_pattern_guard_top.vcd");
        $dumpvars(0, tb_pattern_guard_top);

        rst_n = 0;
        serial_in = 0;
        hold_state = 0;
        freeze_history = 0;
        clear_counter = 0;
        scrub_history = 0;
        expected_state = 3'b000;
        expected_history = 4'b0000;
        expected_count = 2'b00;
        expected_maxed = 1'b0;
        expected_pulse_now = 1'b0;
        expected_pre_flag_now = 1'b0;
        #3;
        if (curr_state !== 0 || detection_count !== 0 || history_window !== 0 || pre_match_flag !== 0) begin
            $fatal(1, "Outputs should reset to zero");
        end

        rst_n = 1;
        for (round = 0; round < 2; round = round + 1) begin
            for (ctrl = 0; ctrl < 16; ctrl = ctrl + 1) begin
                for (bit_in = 0; bit_in < 2; bit_in = bit_in + 1) begin
                    @(negedge clk);
                    hold_state       = ctrl[0];
                    freeze_history = ctrl[1];
                    clear_counter  = ctrl[2];
                    scrub_history  = ctrl[3];
                    serial_in      = bit_in[0];

                    next_state_calc = {expected_state[1:0], serial_in};
                    match_prev = ({expected_state, serial_in} == 4'b1101) || ({expected_state, serial_in} == 4'b1011);
                    pre_prev   = ({expected_state, serial_in} == 4'b1100) || ({expected_state, serial_in} == 4'b1010);
                    inc_double_prev = pre_prev & ~hold_state & ~match_prev;
                    expected_pulse_now = match_prev & ~hold_state;
                    expected_pre_flag_now = pre_prev & ~hold_state;

                    #1;
                    if (detection_pulse !== expected_pulse_now) begin
                        $fatal(1, "Pulse mismatch before clock: expected %0b got %0b", expected_pulse_now, detection_pulse);
                    end
                    if (pre_match_flag !== expected_pre_flag_now) begin
                        $fatal(1, "Pre-match flag mismatch before clock: expected %0b got %0b", expected_pre_flag_now, pre_match_flag);
                    end

                    @(posedge clk);
                    #1;
                    if (!rst_n) begin
                        expected_state   = 3'b000;
                        expected_history = 4'b0000;
                        expected_count   = 2'b00;
                    end else begin
                        if (clear_counter || scrub_history) begin
                            expected_state = 3'b000;
                        end else if (!hold_state) begin
                            expected_state = next_state_calc;
                        end

                        if (scrub_history) begin
                            expected_history = 4'b0000;
                        end else if (!freeze_history) begin
                            expected_history = {expected_history[2:0], serial_in};
                        end

                        if (clear_counter) begin
                            expected_count = 2'b00;
                        end else if (!hold_state) begin
                            if (inc_double_prev && expected_count != 2'b11) begin
                                if (expected_count >= 2) expected_count = 2'b11;
                                else expected_count = expected_count + 2'b10;
                            end else if (expected_pulse_now && expected_count != 2'b11) begin
                                expected_count = expected_count + 2'b01;
                            end
                        end
                    end
                    expected_maxed = (expected_count == 2'b11);

                    if (curr_state !== expected_state) begin
                        $fatal(1, "State mismatch: expected %0b got %0b", expected_state, curr_state);
                    end
                    if (history_window !== expected_history) begin
                        $fatal(1, "History mismatch: expected %0b got %0b", expected_history, history_window);
                    end
                    if (detection_count !== expected_count) begin
                        $fatal(1, "Count mismatch: expected %0b got %0b", expected_count, detection_count);
                    end
                    if (detection_maxed !== expected_maxed) begin
                        $fatal(1, "Max flag mismatch: expected %0b got %0b", expected_maxed, detection_maxed);
                    end
                end
            end
        end

        // Test scrub-only path while FSM held
        @(negedge clk);
        hold_state = 1;
        freeze_history = 0;
        clear_counter = 0;
        scrub_history = 1;
        serial_in = 1;
        expected_pulse_now = 0;
        expected_pre_flag_now = 0;
        #1;
        if (pre_match_flag !== 0 || detection_pulse !== 0) $fatal(1, "Flags should drop during scrub");
        @(posedge clk);
                    #1;
        expected_state = 3'b000;
        expected_history = 4'b0000;
        expected_count = 2'b00;
        expected_maxed = 1'b0;
        if (curr_state !== 0 || history_window !== 0 || detection_count !== 0) $fatal(1, "Scrub should wipe pipeline");
        scrub_history = 0;
        hold_state = 0;

        // Async reset during activity
        @(negedge clk);
        rst_n = 0;
        #1;
        if (curr_state !== 0 || detection_count !== 0 || history_window !== 0) begin
            $fatal(1, "Async reset did not clear top-level state");
        end
        rst_n = 1;
        @(posedge clk);
                    #1;
        expected_state = 0;
        expected_history = 0;
        expected_count = 0;
        expected_maxed = 0;

        $display("pattern_guard_top: comprehensive checks passed");
        $finish;
    end
endmodule