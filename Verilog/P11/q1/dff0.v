module dff0(input clk, reset, d, output reg q);
    always @(posedge clk) begin
        if(reset) q<=1'b0;
        else q<=d;
    end
endmodule