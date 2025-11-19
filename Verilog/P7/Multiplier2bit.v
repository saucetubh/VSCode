/* it is very simple with behavioral modeling
module m2bit(input [1:0]A, input [1:0]B, output reg [3:0]AB);
    always @(*) begin
        AB = A*B;
    end
endmodule
*/
`include "half_adder.v"
module m2bit(input [1:0]A, input [1:0]B, output [3:0]AB);
    assign AB = A * B; //very simple with assign statement and dataflow modeling
/*
    wire w1, w2, w3;
    wire c1, c2;
    and A1(AB[0], A[0], B[0]);
    and A2(w1, A[1], B[0]);
    and A3(w2, B[1], A[0]);
    and A4(w3, A[1], B[1]);
    halfadder HA1(w1, w2, c1, AB[1]);
    halfadder HA2(w3, c1, c2, AB[2]);
    buf B1(AB[3], c2);
*/
endmodule