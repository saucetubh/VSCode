module d_latch_9bit (
    input  [8:0] D,
    input        clk,
    input        reset,
    input        EN,
    output reg [8:0] Q
);
always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) begin
        Q=9'b0;
    end
    else begin
        if(EN == 1'b1) begin
            Q=D;
        end
    end
end
endmodule
