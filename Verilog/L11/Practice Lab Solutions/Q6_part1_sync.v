module dff(input clk, input rst, input d, output reg q);

always @ (posedge clk or posedge rst) begin
    if (rst) q <= 1'b0;
    else q <= d;
end

endmodule

module up_counter(input clk, reset, output[2:0] counter);

wire count6 = (counter[2] & counter[1] & ~counter[0]);
wire internal_reset = reset | count6;

wire [2:0]d;

dff d1(clk, internal_reset, d[0], counter[0]);
dff d2(clk, internal_reset, d[1], counter[1]);
dff d3(clk, internal_reset, d[2], counter[2]);

assign d = {counter[2] ^ (counter[1] & counter[0]), counter[1] ^ counter[0], ~counter[0]};

endmodule