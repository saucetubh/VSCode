`include "register.v"
module direction_fsm (
    input wire clk,
    input wire reset_n,
    input wire turn_right,
    output wire [1:0] direction
);
parameter[1:0] NORTH = 2'b00;
parameter[1:0] SOUTH = 2'b10;
parameter[1:0] EAST = 2'b01;
parameter[1:0] WEST = 2'b11;

wire[1:0] current_state; //the direction i am currently facing in the clock cycle. After transition at clock edge, current state is updated to the calculated next_state. Thus that is where i am facing in the following clock cycle.
assign direction = current_state; //continuously assigns
reg[1:0] next_state; //reg since it is assigned inside the always block
always @(*) begin
    case(current_state)
    NORTH: next_state = turn_right ? EAST : WEST;
    SOUTH: next_state = turn_right ? WEST : EAST;
    EAST: next_state = turn_right ? SOUTH : NORTH;
    WEST: next_state = turn_right ? NORTH : SOUTH;
    endcase
end
//flip flop is needed to store the state between clock cycles, because otherwise this code has no memory

register2bit r1(clk, reset_n, next_state, current_state); //updates current state of the upcoming clock cycle to the next state calculated in the given clock cycle

endmodule