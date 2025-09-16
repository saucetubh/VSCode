`timescale 1ns/1ps
`include "src/higher_order_muxes.v"

module tb_muxes;

    // Signals for 6:3 MUX
    reg  [2:0] in0_3, in1_3;
    reg        sel_3;
    wire [2:0] out_3;

    // Signals for 8:4 MUX
    reg  [3:0] in0_4, in1_4;
    reg        sel_4;
    wire [3:0] out_4;

    // Instantiate 6:3 mux
    mux_6to3 uut6 (
        .in0(in0_3),
        .in1(in1_3),
        .sel(sel_3),
        .y(out_3)
    );

    // Instantiate 8:4 mux
    mux_8to4 uut8 (
        .in0(in0_4),
        .in1(in1_4),
        .sel(sel_4),
        .y(out_4)
    );

    initial begin
        $dumpfile("public/vcd/wave_higher_order_muxes.vcd");
        $dumpvars(0, tb_muxes);

        // --- Test 6:3 MUX ---
        $display("\nTesting 6:3 MUX\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|",
                 "Time", "in0", "in1", "sel", "y");
        $display("|-----|-----|-----|-----|-----|");

        in0_3 = 3'b010; in1_3 = 3'b101; sel_3 = 1'b0; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_3, in1_3, sel_3, out_3);

        in0_3 = 3'b010; in1_3 = 3'b101; sel_3 = 1'b1; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_3, in1_3, sel_3, out_3);

        in0_3 = 3'b111; in1_3 = 3'b000; sel_3 = 1'b0; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_3, in1_3, sel_3, out_3);

        in0_3 = 3'b100; in1_3 = 3'b101; sel_3 = 1'b0; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_3, in1_3, sel_3, out_3);

        in0_3 = 3'b001; in1_3 = 3'b110; sel_3 = 1'b1; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_3, in1_3, sel_3, out_3);

        in0_3 = 3'b010; in1_3 = 3'b011; sel_3 = 1'b1; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_3, in1_3, sel_3, out_3);

        // --- Test 8:4 MUX ---
        $display("\nTesting 8:4 MUX\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|",
                 "Time", "in0", "in1", "sel", "y");
        $display("|-----|-----|-----|-----|-----|");

        in0_4 = 4'b1010; in1_4 = 4'b0111; sel_4 = 1'b0; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_4, in1_4, sel_4, out_4);

        in0_4 = 4'b0110; in1_4 = 4'b1001; sel_4 = 1'b1; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_4, in1_4, sel_4, out_4);

        in0_4 = 4'b0111; in1_4 = 4'b0100; sel_4 = 1'b0; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_4, in1_4, sel_4, out_4);

        in0_4 = 4'b1100; in1_4 = 4'b1101; sel_4 = 1'b0; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_4, in1_4, sel_4, out_4);

        in0_4 = 4'b0001; in1_4 = 4'b1110; sel_4 = 1'b1; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_4, in1_4, sel_4, out_4);

        in0_4 = 4'b0101; in1_4 = 4'b0011; sel_4 = 1'b1; #10;
        $display("|%-5d|%-5b|%-5b|%-5b|%-5b|",
                 $time, in0_4, in1_4, sel_4, out_4);

        #10 $finish;
    end

endmodule
