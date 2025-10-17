module finite_automaton (
    input        clk,
    input        reset,
    input        in_bit, 
    input        in_done, // signal indicating input string is complete
    output reg   found
);
    // state encoding
    parameter S0 = 0,
              S1 = 1,
              S2 = 2,
              S3 = 3,
              S4 = 4;

    // state registers
    reg [2:0] state, next_state;

    // sequential block
    always @(posedge clk) begin
        if(reset) begin
            state <= S0;
        end
        else begin
            state <= next_state;
        end

    end

    // combinational block
    always @(*) begin
        case (state)
            S0: begin
                if(in_bit) next_state = S0;
                else if(~in_bit) next_state = S1;
                /*< WRITE YOUR CODE HERE >*/

            end

            S1: begin
                if(in_bit) next_state = S2;
                else if(~in_bit) next_state = S1;
                /*< WRITE YOUR CODE HERE >*/

            end

            S2: begin
                if(in_bit) next_state = S0;
                else if(~in_bit) next_state = S3;
                /*< WRITE YOUR CODE HERE >*/

            end

            S3: begin
                if(in_bit) next_state = S4;
                else if(~in_bit) next_state = S1;
                /*< WRITE YOUR CODE HERE >*/

            end

            S4: begin
                if(in_bit) next_state = S4;
                else if(~in_bit) next_state = S4;
                /*< WRITE YOUR CODE HERE >*/
                
            end

            default: next_state = S0;
        endcase
    end

    // output logic - only set found when input is complete AND current state is S4

    always @(*) begin
        found = 1'b0;
        if(state == S4 && in_done) begin
            found = 1'b1;
        end
        /*< WRITE YOUR CODE HERE >*/

    end

endmodule
