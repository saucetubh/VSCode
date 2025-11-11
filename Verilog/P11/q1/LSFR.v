`include "dff0.v"
`include "dff1.v"
module LSFR(input clk, set, output wire[3:0] A);
    /* //implementation without d flip flops, output should be reg
    always@(posedge clk) begin
        if(set) begin
            A <= 4'b1001;
        end
        else begin
            A[3] <= A[0]^A[2];
            A[2] <= A[3];
            A[1] <= A[2];
            A[0] <= A[1];
        end
    end
    */ 
    //structural implementation using d flip flops, output should be wire
    dff1 d1(clk, set, (A[2]^A[0]), A[3]);
    dff0 d2(clk, set, A[3], A[2]);
    dff0 d3(clk, set, A[2], A[1]);
    dff1 d4(clk, set, A[1], A[0]);
endmodule