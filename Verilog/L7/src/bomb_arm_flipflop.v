module bomb_arm_flipflop(
    input wire clk,
    input wire arm_cmd,
    input wire reset_cmd,
    output reg armed
);
    always @(posedge clk) begin
        if(reset_cmd) begin
            armed <= 1'b0;
        end
        else if(arm_cmd) begin
            armed <= 1'b1;
        end
    end
endmodule
