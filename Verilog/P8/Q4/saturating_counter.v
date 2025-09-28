module saturating_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire inc_single,
    input  wire inc_double,
    input  wire clr,
    output reg  [1:0] count,
    output wire       at_max
);

endmodule