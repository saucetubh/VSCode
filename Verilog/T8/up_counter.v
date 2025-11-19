module up_counter (
    input clk,
    input reset, //active high synchronous reset
    output reg[2:0] out
);
    always @(posedge clk) begin
        if (reset) begin
            out <= 3'b000;
        end else begin
            out <= out + 1; //how does this wrap around automatically? i.e go from 111 to 000 -> because of overflow 
        end
    end
endmodule