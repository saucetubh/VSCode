// top_pattern_detector.v
`include "shift_reg.v"
`include "pattern_detector.v"
module top_pattern_detector(
    input wire clk,
    input wire reset,
    input wire in_bit,
    output wire detected
);
    wire [3:0] shift_q;

    // Instantiate shift register
    shift_reg sr_inst (
        .clk(clk),
        .reset(reset),
        .in_bit(in_bit),
        .q(shift_q)
    );

    // Instantiate pattern detector
    pattern_detector pd_inst (
        .shift_reg_value(shift_q),
        .detected(detected)
    );
endmodule
