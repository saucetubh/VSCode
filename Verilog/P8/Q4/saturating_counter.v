module saturating_counter (
    input  wire clk,
    input  wire rst_n,
    input  wire inc_single,
    input  wire inc_double,
    input  wire clr,
    output reg  [1:0] count,
    output wire       at_max
);
    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 0) begin
            count <= 0;
        end
        else if(clr == 1) begin
            count <= 0;
        end
        else if(count < 3) begin
            case({inc_double, inc_single})
            1: count <= count + 1;
            2: begin
                if(count == 2) begin
                    count <= 3;
                end
                else count <= count + 2;
            end
            3: count <= 3;
            endcase
        end
    end
    assign at_max = count[0] & count[1]; //assign at_max = (count == 2'd3);
//we want value of count to be carried over in the next cycle, and only made 0 when specifically cleared. Hence we do not assign it to 0 in always block.
endmodule