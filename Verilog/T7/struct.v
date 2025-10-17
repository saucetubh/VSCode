// shift_reg_struct.v
`include "dff.v"

module shift_reg_struct(
    input wire clk,
    input wire reset,
    input wire in_bit,
    output wire [3:0] q
);
    wire q0, q1, q2, q3;

    // Connect each DFF in series (shift left)
    dff dff0(.clk(clk), .reset(reset), .d(in_bit),   .q(q0));
    dff dff1(.clk(clk), .reset(reset), .d(q0),     .q(q1));
    dff dff2(.clk(clk), .reset(reset), .d(q1),     .q(q2));
    dff dff3(.clk(clk), .reset(reset), .d(q2),     .q(q3));

    // Combine outputs
    assign q = {q3, q2, q1, q0};
endmodule

//structural implementation of shift register using D flip-flops