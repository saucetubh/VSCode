`timescale 1ns/1ps
`include "../Q1/gated_dff.v"
`include "state_register3.v"

module tb_state_register3;
    reg clk;
    reg rst_n;
    reg load;
    reg [2:0] hold_mask;
    reg scrub;
    reg [2:0] next_state;
    wire [2:0] curr_state;
    reg [2:0] expected;

    state_register3 uut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .hold_mask(hold_mask),
        .scrub(scrub),
        .next_state(next_state),
        .curr_state(curr_state)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task check_state;
        begin
            @(posedge clk);
            #1;
            if (curr_state !== expected) begin
                $fatal(1, "State mismatch: expected %0b got %0b", expected, curr_state);
            end
        end
    endtask

    integer value;
    initial begin
        $dumpfile("tb_state_register3.vcd");
        $dumpvars(0, tb_state_register3);

        load = 0;
        hold_mask = 3'b000;
        scrub = 0;
        next_state = 3'b000;
        rst_n = 0;
        expected = 3'b000;
        #2;
        check_state();

        rst_n = 1;
        // Sweep through all possible next_state values with load asserted
        for (value = 0; value < 8; value = value + 1) begin
            next_state = value[2:0];
            load = 1;
            hold_mask = 3'b000;
            scrub = 0;
            expected = next_state;
            check_state();
        end

        // Apply selective hold on bit 1 while updating others
        load = 1;
        hold_mask = 3'b010;
        next_state = 3'b000;
        expected = {next_state[2], expected[1], next_state[0]};
        check_state();

        // Release hold and update all bits again
        hold_mask = 3'b000;
        next_state = 3'b101;
        expected = next_state;
        check_state();

        // Keep state frozen via hold mask even though load toggles
        hold_mask = 3'b111;
        load = 1;
        next_state = 3'b010;
        expected = expected; // unchanged
        check_state();

        // Scrub should clear regardless of hold mask or load
        hold_mask = 3'b111;
        load = 0;
        scrub = 1;
        expected = 3'b000;
        check_state();
        scrub = 0;

        // Drive to a non-zero state then pulse async reset mid-cycle
        hold_mask = 3'b000;
        load = 1;
        next_state = 3'b101;
        expected = next_state;
        check_state();
        #1;
        rst_n = 0;
        expected = 3'b000;
        #1;
        if (curr_state !== expected) $fatal(1, "Async reset failed to clear state");
        load = 1'b0;
        hold_mask = 3'b000;
        scrub = 1'b0;
        next_state = 3'b000;
        rst_n = 1;
        @(posedge clk);
        #1;
        if (curr_state !== expected) $fatal(1, "State should remain reset after releasing rst");

        $display("state_register3: all cases covered");
        $finish;
    end
endmodule