`include "src/button_sync.v"

module lock(
    input       clk, 
    input       reset_in, 
    input       b0_in, 
    input       b1_in, 
    output reg  unlock
);
    
    // synchronize push buttons, convert to pulses
    wire reset, b0, b1; 
    button_sync b_reset(clk, reset_in, reset);
    button_sync b_0(clk, b0_in, b0);
    button_sync b_1(clk, b1_in, b1);

    // b0 corresponds to transition 0, b1 corresponds to transition 1

    /* 
    steps:
    1. declare parameters for states
    2. declare state registers called 'state' and 'next_state'
    3. sequential always block for reset and state update
    4. combinational always block for FSM logic
    */
    
    /*< WRITE YOUR CODE HERE >*/
    parameter[2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;
    reg[2:0] state, next_state;
    // sequential block
    always @(posedge clk) begin
        if(reset) state <= S0;
        else state <= next_state;
        /*< WRITE YOUR CODE HERE >*/

    end

    // combinational block
    always @(*) begin
        next_state = state; // if no input, stay in current state by default, don't remove this
        
        case (state)
            S0: begin
                unlock=0;
                if(b0) next_state = S1;
                else if(b1) next_state = S0;
            end
            S1: begin
                unlock=0;
                if(b0) next_state = S1;
                else if(b1) next_state = S2;                
            end
            S2: begin
                unlock=0;
                if(b0) next_state = S3;
                else if(b1) next_state = S0;               
            end
            S3: begin
                unlock=0;
                if(b0) next_state = S1;
                else if(b1) next_state = S4;               
            end
            S4: begin
                unlock=0;
                if(b0) next_state = S3;
                else if(b1) next_state = S5;               
            end
            S5: begin
                unlock=1;
                if(b0) next_state = S1;
                else if(b1) next_state = S0;       
            end
            default: next_state = S0;
        endcase

    end

endmodule