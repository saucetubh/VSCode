// shift_reg.v
// shift left 4 bit, insert new bit at LSB
module shift_reg(
    input wire clk,
    input wire reset,
    input wire in_bit,
    output reg [3:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000; // Reset to 0
        end else begin
            q <= {q[2:0], in_bit}; // Shift left and insert new bit at LSB
        end
    end
endmodule
