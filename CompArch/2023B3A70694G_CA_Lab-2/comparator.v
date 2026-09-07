module Comparator_16bits(input [15:0] input1, input [15:0] input2, output reg lesser_than, output reg equal, output reg greater_than);
    always @(*) begin
        greater_than = (input1 > input2) ? 1'b1 : 1'b0;
        lesser_than = (input1 < input2) ? 1'b1 : 1'b0;
        equal = (input1 == input2) ? 1'b1 : 1'b0;
    end
endmodule