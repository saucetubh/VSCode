module code_progressor(
    input wire clk,
    input wire armed,
    input wire code_bit,
    output reg [1:0] stage
);
    reg[1:0] next_stage;
    always @(*) begin
        case(stage)
        2'b00: next_stage = code_bit ? 2'b01 : 2'b00;
        2'b01: next_stage = code_bit ? 2'b01 : 2'b10;
        2'b10: next_stage = code_bit ? 2'b11 : 2'b00;
        2'b11: next_stage = code_bit ? 2'b01 : 2'b10;
        endcase
    end
    always @(posedge clk) begin
        if(!armed) begin
            stage<=2'b0;
        end
        else begin
            stage[0] <= next_stage[0];
            stage[1] <= next_stage[1];
        end
    end
endmodule
