`include "mux_2to1.v"
module tb_mux2to1;

    reg a, b, sel;       // Inputs
    wire y;              // Output

    // Instantiate the MUX
    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("mux2to1_tb.vcd");   // For waveform viewing (if using GTKWave)
        $dumpvars(0, tb_mux2to1);

        // Test all possible cases
        $display("SEL A B | Y");
        $display("---------|---");

        sel = 0; a = 0; b = 0; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        sel = 0; a = 0; b = 1; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        sel = 0; a = 1; b = 0; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        sel = 0; a = 1; b = 1; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        sel = 1; a = 0; b = 0; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        sel = 1; a = 0; b = 1; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        sel = 1; a = 1; b = 0; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        sel = 1; a = 1; b = 1; #10;
        $display(" %b   %b %b | %b", sel, a, b, y);

        $finish;
    end

endmodule
