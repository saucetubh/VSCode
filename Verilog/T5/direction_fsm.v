`include "flipflop.v"
module direction_fsm (
    input wire clk,
    input wire reset_n,
    input wire turn_right,
    output wire [1:0] direction
);
parameter [1:0] NORTH = 2'b00; //parameter is used to define constant values that will simply we replaced during compilation
parameter [1:0] EAST  = 2'b01, SOUTH = 2'b10, WEST  = 2'b11;

reg[1:0] next_state; //reg because it is assigned in always block
wire[1:0] current_state; //wire because it is continuously driven by flipflop output, and flipflop can only take wires

assign direction = current_state; //continuously assign the value of current_state to direction output
always @(*) begin //combinational logic, so use *
    case (current_state)
        NORTH: next_state = turn_right ? EAST  : WEST;
        EAST:  next_state = turn_right ? SOUTH : NORTH;
        SOUTH: next_state = turn_right ? WEST  : EAST;
        WEST:  next_state = turn_right ? NORTH : SOUTH;
        default: next_state = NORTH; //safety
    endcase
end
d_flipflop ff1 (
    .clk(clk),
    .reset_n(reset_n),
    .d(next_state[0]),
    .q(current_state[0])
);
d_flipflop ff2 (
    .clk(clk),
    .reset_n(reset_n),
    .d(next_state[1]),
    .q(current_state[1])
);
endmodule


//4states - N,S,E,W -> assuume any 2bit values to this state -> say 00 01 10 11 respectively
//4 states -> 2 flipflops, asynchronous reset flip flop 
//suppose left = 0, right = 1, i.e when input is 1 i want to go right, when input is 0 i want to go left
//make the state diagram and excitation table according to this


//non-blocking assignments are used in sequential logic (like flip-flops) to ensure that all right-hand side expressions are evaluated before any left-hand side assignments are made.
//mainly used when output is being used as input in the same always block