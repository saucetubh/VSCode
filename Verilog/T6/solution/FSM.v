module FSM (input clk, input reset, input in, output reg out);
    reg [1:0]state;
    reg [1:0]nextState;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

    always @(posedge clk, posedge reset) begin
        if(reset) 
            state <= S0;
        else
            state <= nextState;
    end

    always @(state, in) begin
        case (state)
              S0: begin
                if(!in) begin
                    nextState = S0;
                    out = 1'b1;
                end
                else begin
                    nextState = S1;
                    out = 1'b0;
                end
              end
              S1: begin
                if(!in) begin
                    nextState = S1;
                    out = 1'b0;
                end
                else begin
                    nextState = S2;
                    out = 1'b0;
                end
              end
              S2: begin
                if(!in) begin
                    nextState = S2;
                    out = 1'b0;
                end
                else begin
                    nextState = S0;
                    out = 1'b1;
                end
              end
        endcase
    end
endmodule