module FSM (input clk, input reset, input in, output reg out);
    // declare state variables as 'reg' type since they need to retain their values across clock cycles
    reg [1:0] state, nextstate; //must use state as the variable name because of testbench
    parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;  // parameters are used to assign aliases to constant values
    always @(posedge clk or posedge reset) begin  // always block for reset and state update //reset is asynchronous active high
        if(reset) state <= S0; //nonblocking assignment for sequential logic
        else state <= nextstate;
    end
    // always block for FSM logic - nextState and output
    always @(state, in) begin
        case (state)
        S0: begin
            if(!in) begin
                nextstate = S0;
                out = 1'b1;
            end
            else if(in) begin
                nextstate = S1;
                out = 1'b0;
            end
        end
        S1: begin
            if(!in) begin
                nextstate = S1;
                out = 1'b0;
            end
            else if(in) begin
                nextstate = S2;
                out = 1'b0;
            end
        end
        S2: begin
            if(!in) begin
                nextstate = S2;
                out = 1'b0;
            end
            else if(in) begin
                nextstate = S0;
                out = 1'b1;
            end
        end
        default: begin
            nextstate = 2'b00; //blocking assignment for combinational logic
            out = 1'b0;
        end
        endcase
    end
endmodule