module strike_counter(
    input wire clk,
    input wire armed,
    input wire strike_bit,
    output reg [1:0] strikes
);
    reg[1:0] next_strike;
    always @(*) begin
            case(strikes)
            2'b00: next_strike = strike_bit ? strikes + 1 : strikes;
            2'b01: next_strike = strike_bit ? strikes + 1 : strikes;
            2'b10: next_strike = strikes;
            endcase
    end
    always @(posedge clk) begin
        if(!armed) begin
            strikes <= 0;
        end
        else begin
            strikes[0] <= next_strike[0];
            strikes[1] <= next_strike[1];
        end
    end
endmodule
