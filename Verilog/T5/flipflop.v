module d_flipflop (
    input wire clk,
    input wire reset_n,
    input wire d,
    output reg q
);
always @(posedge clk or negedge reset_n) begin //if i simply write clk then it will sample when clock is 1, but this is a flipflop so it should sample at the positive edge of clock
    if (!reset_n) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end
endmodule

//reset_n is active low reset, hence the negedge. This is asynchronous reset since it is independent of clock. If reset_n is low, q is set to 0 immediately regardless of clock. If reset_n is high, q takes the value of d at the positive edge of clk.
//with posedge or negedge, i.e flipflops, we use non-blocking assignments (<=) to avoid race conditions and ensure proper behavior in sequential logic.
//with <= , all rhs expressions are evaluated first, then all lhs are updated. This is important in sequential logic to ensure that all flipflops update their values simultaneously at the clock edge.
//without this, it would be possible for one flipflop to update its value and then another flipflop to read that updated value in the same clock cycle, leading to unintended behavior.
//with blocking assignments (=) inside the always block, the assignments are done in the order they appear in the code, same as procedural programming languages like C.

//for a synchronous reset, we would write:
/*
always @(posedge clk) begin
    if (!reset_n) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end    
end
*/
//here, reset_n is checked only at the positive edge of clk. If reset_n is low at that moment, q is set to 0. Otherwise, q takes the value of d.