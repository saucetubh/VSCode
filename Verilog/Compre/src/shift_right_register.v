// shift_right_register.v

module shift_right_register (
    input clk,
    input reset,
    input hold,
    input[3:0] shift_in,
    input[31:0] init_val,
    output reg[31:0] data,
    output reg[3:0] shift_out
);
    always @(negedge clk) begin
        if(reset) begin
            data <= init_val;
            shift_out <= 4'b0;
        end
        else begin
            if(~hold) begin
                shift_out <= data[3:0];                
                data <= {shift_in, data[31:4]}; 
            end
        end
    end
    
endmodule
