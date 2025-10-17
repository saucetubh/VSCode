//we will be using a binary tree (and then simplifying by reducing equivalent states -> theory)
module nonoverlap (input clk, input reset, input in, output reg[1:0]out);
    reg[2:0] state, next_state;
    parameter[2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101, S6=3'b110;
    always @(posedge clk or posedge reset) begin
        if(reset) state <= S0;
        else state <= next_state;
    end
    always @(state, in) begin
        case(state)
        S0: begin
            if(~in) begin
                next_state = S1;
                out = 2'b00;
            end
            else if(in) begin
                next_state = S2;
                out = 2'b00;
            end
        end
        S1: begin
            if(~in) begin
                next_state = S3;
                out = 2'b00;
            end
            else if(in) begin
                next_state = S4;
                out = 2'b00;
            end
        end
        S2: begin
            if(~in) begin
                next_state = S5;
                out = 2'b00;
            end
            else if(in) begin
                next_state = S6;
                out = 2'b00;
            end
        end
        S3: begin
            if(~in) begin
                next_state = S0;
                out = 2'b00;
            end
            else if(in) begin
                next_state = S0;
                out = 2'b00;
            end
        end
        S4: begin
            if(~in) begin
                next_state = S0;
                out = 2'b00;
            end
            else if(in) begin
                next_state = S0;
                out = 2'b01;
            end
        end
        S5: begin
            if(~in) begin
                next_state = S0;
                out = 2'b00;
            end
            else if(in) begin
                next_state = S0;
                out = 2'b00;
            end
        end
        S6: begin
            if(~in) begin
                next_state = S0;
                out = 2'b00;
            end
            else if(in) begin
                next_state = S0;
                out = 2'b10;
            end
        end
        endcase
    end
endmodule