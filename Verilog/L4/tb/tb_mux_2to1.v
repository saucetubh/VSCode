`include "src/mux_2to1.v"

module tb_mux_2to1;

    // Inputs
    reg in0, in1, sel;

    // Output
    wire y;

    // Instantiate the mux
    mux_2to1 uut (
        .y(y),
        .in0(in0),
        .in1(in1),
        .sel(sel)
    );

    initial begin
        $dumpfile("public/vcd/wave_mux_2to1.vcd");
        $dumpvars(0, tb_mux_2to1);

        $display("\nTesting 2-to-1 Multiplexer\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|", "Time", "in0", "in1", "sel", "y");
        $display("|-----|-----|-----|-----|-----|");

        $monitor("|%-5d|%-5b|%-5b|%-5b|%-5b|", $time, in0, in1, sel, y);

        // Apply test cases
            in0 = 0; in1 = 0; sel = 0;
        #10 in0 = 0; in1 = 0; sel = 1;
        #10 in0 = 0; in1 = 1; sel = 0;
        #10 in0 = 0; in1 = 1; sel = 1;
        #10 in0 = 1; in1 = 0; sel = 0;
        #10 in0 = 1; in1 = 0; sel = 1;
        #10 in0 = 1; in1 = 1; sel = 0;
        #10 in0 = 1; in1 = 1; sel = 1;

        #10 $finish;
    end

endmodule
