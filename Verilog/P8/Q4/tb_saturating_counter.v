`timescale 1ns/1ps
`include "saturating_counter.v"

module tb_saturating_counter;
    reg clk;
    reg rst_n;
    reg inc_single;
    reg inc_double;
    reg clr;
    wire [1:0] count;
    wire at_max;
    reg [1:0] expected;

    saturating_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .inc_single(inc_single),
        .inc_double(inc_double),
        .clr(clr),
        .count(count),
        .at_max(at_max)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer combo;
    integer round;
    reg [1:0] prev_expected;
    reg [2:0] sum;

    initial begin
        $dumpfile("tb_saturating_counter.vcd");
        $dumpvars(0, tb_saturating_counter);

        rst_n = 0;
        inc_single = 0;
        inc_double = 0;
        clr = 0;
        expected = 2'b00;
        #2;
        if (count !== 0 || at_max !== 0) $fatal(1, "Reset should force count=0");

        rst_n = 1;
        for (round = 0; round < 4; round = round + 1) begin
            for (combo = 0; combo < 8; combo = combo + 1) begin
                @(negedge clk);
                inc_single = combo[0];
                inc_double = combo[1];
                clr = combo[2];
                prev_expected = expected;
                @(posedge clk);
                if (!rst_n) begin
                    expected = 2'b00;
                end else if (clr) begin
                    expected = 2'b00;
                end else if (inc_double && prev_expected != 2'b11) begin
                    sum = {1'b0, prev_expected} + 3'd2;
                    if (sum[2] || sum[1:0] >= 2'b11) expected = 2'b11;
                    else expected = sum[1:0];
                end else if (inc_single && prev_expected != 2'b11) begin
                    expected = prev_expected + 2'b01;
                end else begin
                    expected = prev_expected;
                end
                #1;
                if (count !== expected) begin
                    $fatal(1, "Count mismatch: inc_single=%0b inc_double=%0b clr=%0b prev=%0b expected=%0b got=%0b",
                           inc_single, inc_double, clr, prev_expected, expected, count);
                end
                if (at_max !== (expected == 2'b11)) begin
                    $fatal(1, "at_max incorrect: expected %0b got %0b", (expected == 2'b11), at_max);
                end
            end
        end

        // Drive to saturation using double steps then single steps
        @(negedge clk);
        inc_double = 1;
        inc_single = 0;
        clr = 0;
        repeat (2) begin
            prev_expected = expected;
            @(posedge clk);
            if (prev_expected != 2'b11) begin
                sum = {1'b0, prev_expected} + 3'd2;
                expected = (sum[2] || sum[1:0] >= 2'b11) ? 2'b11 : sum[1:0];
            end
            #1;
        end
        if (count !== expected) $fatal(1, "Double-step sequence mismatch");

        @(negedge clk);
        inc_double = 0;
        inc_single = 1;
        @(posedge clk);
        #1;
        if (count !== 2'b11) $fatal(1, "Failed to saturate at 3 after mixed increments");

        #2;
        rst_n = 0;
        #1;
        if (count !== 2'b00) $fatal(1, "Async reset failed to clear counter");
        rst_n = 1;
        inc_single = 0;
        inc_double = 0;
        clr = 0;
        @(posedge clk);
        #1;
        if (count !== 2'b00) $fatal(1, "Counter should remain 0 after reset release");

        $display("saturating_counter: all cases covered");
        $finish;
    end
endmodule