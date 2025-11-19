// marks_calculator.v

module marks_calculator(
    input clk,
    input reset,
    input[3:0] submission,
    input[3:0] key,
    output reg[4:0] marks
);
    always @(posedge clk) begin
        if(reset) begin
            marks <= 4'b0000;
        end
        else begin
            if(submission == 4'b0000) begin
                marks <= marks;
            end
            else begin
                if(submission == key) begin
                    marks <= marks + 4'd3;
                end 
                else begin
                    if(submission < key) begin
                        marks <= marks + 4'd1;
                    end       
                end
            end
        end
    end
endmodule