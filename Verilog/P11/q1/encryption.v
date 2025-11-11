`include "dff0.v"
`include "dff1.v"
module encryption(input clk, set, in, output reg [3:0]A, output out);
    //with output reg
    always @(posedge clk) begin
        if(set) A<=4'b0010;
        else begin
            A <= {A[1]^A[0], A[3], A[2], A[1]};
            //out <= in ^ A[0]; //doesnt work correctly
        end
    end
    /*
    dff0 d1(clk, set, A[0]^A[1], A[3]);
    dff0 d2(clk, set, A[3], A[2]);
    dff1 d3(clk, set, A[2], A[1]);
    dff0 d4(clk, set, A[1], A[0]);
    */
    assign out = in^A[0];
endmodule