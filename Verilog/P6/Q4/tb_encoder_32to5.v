`include "encoder_32to5.v"
module tb_encoder32to5;

    reg [31:0] in;
    wire [4:0] out;

    // Instantiate the encoder
    encoder32to5 uut (
        .in(in),
        .out(out)
    );

    integer i;

    initial begin
        $dumpfile("encoder32to5_tb.vcd"); // for GTKWave
        $dumpvars(0, tb_encoder32to5);

        $display("Input Position | Encoded Output");
        $display("-------------------------------");

        // Apply one-hot inputs
        for (i = 0; i < 32; i = i + 1) begin
            in = 32'b1 << i;  // one-hot at position i
            #5;
            $display("     %2d        |     %2d", i, out);
        end

        $finish;
    end

endmodule
