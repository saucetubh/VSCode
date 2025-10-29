module semaphore_counter(
    input wire clk,
    input wire reset,
    input wire [7:0] init_value,
    input wire up_down,           // 0 = down, 1 = up
    output reg [7:0] sema_count,
    output reg [7:0] queue_count
);
    always @(posedge clk) begin
        if(reset) begin
            sema_count <= init_value;
            queue_count <= 0;
        end
        else if(!up_down) begin
            if(sema_count>0) sema_count <= sema_count-1;
            else if(queue_count<255) queue_count <= queue_count+1;
        end
        else if(up_down) begin
            if(queue_count>0) queue_count <= queue_count-1;
            else if(sema_count < init_value) sema_count <= sema_count+1;
        end
    end
endmodule
