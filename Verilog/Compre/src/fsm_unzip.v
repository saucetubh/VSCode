// fsm_unzip_moore.v

module fsm_unzip (
    input clk,
    input reset,
    input in,
    output reg match,
    output reg[3:0] data
);
    reg match_c;
    reg[3:0] data_c;
    parameter[3:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;
    reg [3:0]state, next_state;
    always @(posedge clk) begin
        if(reset) begin 
            state <= S0;
            match <= 1'b0;
            data <= 4'bz;
        end
        else state <= next_state;
    end
    always @(*) begin
        case(state)
            S0: begin
                if(in) begin
                    data_c = 4'bz;
                    match_c = 1'b0;
                    next_state = S2;
                end
                if(~in) begin
                    data_c = 4'bz;
                    match_c = 1'b0;
                    next_state = S1;
                end
            end
            S1: begin
                if(in) begin
                    data_c = 4'b0101;
                    match_c = 1'b1;
                    next_state = S0;
                end
                if(~in) begin
                    data_c = 4'bz;
                    match_c = 1'b0;
                    next_state = S3;
                end
            end
            S2: begin
                if(in) begin
                    data_c = 4'b0010;
                    match_c = 1'b1;
                    next_state = S0;
                end
                if(~in) begin
                    data_c = 4'bz;
                    match_c = 1'b0;
                    next_state = S4;
                end
            end
            S3: begin
                if(in) begin
                    data_c = 4'b1101;
                    match_c = 1'b1;
                    next_state = S0;
                end
                if(~in) begin
                    data_c = 4'b0111;
                    match_c = 1'b1;
                    next_state = S0;
                end
            end
            S4: begin
                if(in) begin
                    data_c = 4'b0000;
                    match_c = 1'b1;
                    next_state = S0;
                end
                if(~in) begin
                    data_c = 4'b1010;
                    match_c = 1'b1;
                    next_state = S0;
                end
            end
            
        endcase
    end    
    
always @(posedge clk) begin
    match <= match_c;
    data  <= data_c;
end
endmodule