`timescale 1ns/1ps
`include "gated_dff.v"

module tb_gated_dff;
    reg clk;
    reg rst_n;
    reg load;
    reg scrub;
    reg d;
    wire q;
    reg expected;

    gated_dff uut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .scrub(scrub),
        .d(d),
        .q(q)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer combo;
    initial begin
        $dumpfile("tb_gated_dff.vcd");
        $dumpvars(0, tb_gated_dff);

        // Initialize
        rst_n = 0;
        load = 0;
        scrub = 0;
        d = 0;
        expected = 0;
        #2;
        @(posedge clk);
        #1;
        if (q !== 0) $fatal(1, "Q should reset low while rst_n is 0");

        // Release reset and iterate through scrub/load/d combinations
        rst_n = 1;
        for (combo = 0; combo < 8; combo = combo + 1) begin
            @(negedge clk);
            {scrub, load, d} = combo[2:0];
            @(posedge clk);
            if (!rst_n) begin
                expected = 0;
            end else if (scrub) begin
                expected = 0;
            end else if (load) begin
                expected = d;
            end
            #1;
            if (q !== expected) begin
                $fatal(1, "Mismatch after combo %0b: scrub=%0b load=%0b d=%0b expected=%0b got=%0b",
                       combo[2:0], scrub, load, d, expected, q);
            end
        end

        // Verify scrub dominates load regardless of D
        @(negedge clk);
        load = 1;
        d = 1;
        scrub = 1;
        expected = 0;
        @(posedge clk);
        #1;
        if (q !== expected) $fatal(1, "Scrub should dominate load and drive reset value");

        // Capture a one, then scrub synchronously, then async reset mid-cycle
        @(negedge clk);
        scrub = 0;
        load = 1;
        d = 1;
        @(posedge clk);
        expected = 1;
        #1;
        if (q !== expected) $fatal(1, "Failed to capture 1 before scrub test");

        @(negedge clk);
        scrub = 1;
        load = 0;
        @(posedge clk);
        expected = 0;
        #1;
        if (q !== expected) $fatal(1, "Scrub pulse should clear q to 0");

        #2;
        rst_n = 0; // asynchronous reset
        #1;
        if (q !== 0) $fatal(1, "Q should clear asynchronously when rst_n drops");
        rst_n = 1;

        // Ensure hold works after reset
        load = 0;
        scrub = 0;
        d = 1; // irrelevant when load=0
        expected = 0;
        repeat (4) begin
            @(posedge clk);
            #1;
            if (q !== expected) $fatal(1, "Hold failed with load=0 after reset");
        end

        $display("All gated_dff cases passed");
        $finish;
    end
endmodule