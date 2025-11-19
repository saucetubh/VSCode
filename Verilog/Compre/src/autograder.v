// autograder.v
// include relevant modules
`include "fsm_unzip.v"
`include "grade_assigner.v"
`include "marks_calculator.v"
`include "shift_right_register.v"
module autograder(
    input clk,
    input reset,
    input input_stream,
    input[31:0] key,
    output[4:0] marks,
    output[4:0] grade
);
    wire m;
    wire [3:0]uz;
    wire [3:0]k;
    wire [31:0]r1;
    wire [31:0]r2;
    fsm_unzip fsm1(clk, reset, input_stream, m, uz);
endmodule