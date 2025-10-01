module fuse_timer(
    input wire clk,
    input wire armed,
    input wire hold,
    output reg [1:0] time_left
);
    always @(posedge clk) begin
        if(!armed) begin
            time_left <= 3;
        end
        else if((!hold) && (time_left > 0)) begin
            time_left <= time_left - 1;
        end
    end
endmodule
