`include "decoder_5to32.v"
module tb_decoder5to32;

    reg [4:0] in;
    wire [31:0] out;

    // Instantiate the decoder
    decoder5to32 uut (
        .in(in),
        .out(out)
    );

    integer i;

    initial begin
        $dumpfile("decoder5to32_tb.vcd"); // for GTKWave
        $dumpvars(0, tb_decoder5to32);

        $display("Input | One-Hot Output");
        $display("----------------------");

        // Test all 32 possible input values
        for (i = 0; i < 32; i = i + 1) begin
            in = i;
            #5;
            $display("  %2d   | %032b", in, out);
        end

        $finish;
    end

endmodule
