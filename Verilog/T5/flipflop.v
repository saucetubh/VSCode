module d_flipflop (
    input wire clk,
    input wire reset_n,
    input wire d,
    output reg q
); //nededge since i want the code to execute even reset from high to low ??
always @(posedge clk or negedge reset_n) begin //if i simply write clk then it will sample when clock is 1, but this is a flipflop so it should sample at the positive edge of clock
    if (!reset_n) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end
endmodule