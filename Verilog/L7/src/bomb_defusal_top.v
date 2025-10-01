`include "src/bomb_arm_flipflop.v"
`include "src/code_progressor.v"
`include "src/strike_counter.v"
`include "src/fuse_timer.v"

module bomb_defusal_top(
    input wire clk,
    input wire arm_key,
    input wire code_bit,
    output wire safe
);
    wire armed;
    wire [1:0] stage, strikes, time_left;
    reg expected_bit;

    bomb_arm_flipflop BAF(clk, 1'b1, !arm_key, armed);
    code_progressor CP(clk, armed, code_bit, stage);

    always @(*) begin
        case(stage)
        2'b00: expected_bit = 1'b1;
        2'b01: expected_bit = 1'b0;
        2'b10: expected_bit = 1'b1;
        2'b11: expected_bit = 1'b0;
        endcase
    end
    strike_counter SC(clk, armed, (code_bit != expected_bit), strikes);
    fuse_timer FT(clk, armed, (stage == 2'b11), time_left);
    assign safe = ((arm_key == 1'b1) && (stage == 2'b11) && (strikes < 2) && (time_left > 0));
endmodule

