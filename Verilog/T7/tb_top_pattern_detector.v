// tb_top_pattern_detector.v
`include "top_pattern_detector.v"

module tb_top_pattern_detector;
    reg clk;
    reg reset;
    reg in_bit;
    wire detected;

    // Instantiate top module
    top_pattern_detector uut(
        .clk(clk),
        .reset(reset),
        .in_bit(in_bit),
        .detected(detected)
    );

    integer cycle;

    initial clk = 0;
    always #5 clk = ~clk; // 10 time unit clock period

    // Count clock cycles
    always @(posedge clk) begin
        if (!reset) cycle = cycle + 1;
    end

    initial begin
        // Initialize
        reset = 1; in_bit = 0; cycle = 0;
        $display("Cycle | Input Bit | Detected");
        $display("----------------------------");

        #10 reset = 0;

        // Bitstream: 1 0 1 1 0 1 1
        in_bit = 1; #10 $display("%5d |     %b     |    %b", cycle, in_bit, detected);
        in_bit = 0; #10 $display("%5d |     %b     |    %b", cycle, in_bit, detected);
        in_bit = 1; #10 $display("%5d |     %b     |    %b", cycle, in_bit, detected);
        in_bit = 1; #10 $display("%5d |     %b     |    %b", cycle, in_bit, detected); // detected here
        in_bit = 0; #10 $display("%5d |     %b     |    %b", cycle, in_bit, detected);
        in_bit = 1; #10 $display("%5d |     %b     |    %b", cycle, in_bit, detected);
        in_bit = 1; #10 $display("%5d |     %b     |    %b", cycle, in_bit, detected); // detected again

        #20 $finish;
    end
endmodule
