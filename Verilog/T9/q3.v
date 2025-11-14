module DFF_shift(input D, clk, rst, init_val, output reg Q);
    always @(posedge clk or posedge rst) begin
        if(rst) Q <= init_val;
        else Q <= D;
    end
endmodule

module Shiftreg(input clk, rst, ctrl, Incoming, input [3:0]num, output [3:0]out);
    wire din3, din2, din1, din0;
    assign din3 = (ctrl & Incoming) | (~ctrl & out[3]);
    assign din2 = (ctrl & out[3]) | (~ctrl & out[2]);
    assign din1 = (ctrl & out[2]) | (~ctrl & out[1]);
    assign din0 = (ctrl & out[1]) | (~ctrl & out[0]);

    DFF_shift d3(din3, clk, rst, num[3], out[3]);
    DFF_shift d2(din2, clk, rst, num[2], out[2]);
    DFF_shift d1(din1, clk, rst, num[1], out[1]);
    DFF_shift d0(din0, clk, rst, num[0], out[0]);
/*
    always @(posedge clk or posedge rst) begin
        if(rst) out <= num;
        else begin
            if(ctrl) begin
                out <= {Incoming, out[3:1]};
            end
        end
    end
*/ //behavioural modelling
endmodule