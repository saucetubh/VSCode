module dff(input clk, input reset, input d, output reg q);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0; // Reset to 0
        end else begin
            q <= d; // Capture input on clock edge
        end
    end
endmodule
// D flip-flop with asynchronous reset