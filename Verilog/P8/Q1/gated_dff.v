module gated_dff (
    input  wire clk,
    input  wire rst_n,
    input  wire load,
    input  wire scrub,
    input  wire d,
    output reg  q
);
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 0;
    end
    else if (scrub) begin
        q <= 0; //misprint in Q, if scrub is high, it resets Q to 0. this is basically active high synchronous reset
    end
    else if (load) begin
        q <= d;
    end
end
endmodule

//this flip flop essentially has two types of signals. 
//rst_n is active low asynchronous reset, highest priority
//scrub is active high synchronous reset
//load is to decide whether in memory state or sample input d. If load = 0, retain q.
