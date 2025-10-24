`include "jkff.v"
module sync_counter(input clk, input reset, output [3:0] Q);
    wire J0, J1, J2, J3, K0, K1, K2, K3;
    assign J0 = 1'b1;
    assign K0 = 1'b1;
    assign J1 = Q[0];
    assign K1 = Q[0];
    assign J2 = Q[1] & Q[0]; //all these equations were derived from the K-map after making the state table
    assign K2 = Q[1] & Q[0];
    assign J3 = Q[2] & Q[1] & Q[0];
    assign K3 = Q[2] & Q[1] & Q[0];
    jk_ff ff0 (.clk(clk), .reset(reset), .J(J0), .K(K0), .Q(Q[0]));
    jk_ff ff1 (.clk(clk), .reset(reset), .J(J1), .K(K1), .Q(Q[1]));
    jk_ff ff2 (.clk(clk), .reset(reset), .J(J2), .K(K2), .Q(Q[2]));
    jk_ff ff3 (.clk(clk), .reset(reset), .J(J3), .K(K3), .Q(Q[3]));
endmodule