module tff(input clk, input t, input reset, output reg q);
always @(negedge clk or posedge reset) begin
    if(reset) q<=0;
    else if(t) q<=~q;
end
endmodule