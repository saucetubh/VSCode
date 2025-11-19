// 0 - 4 -2 - 6 - 1 - 5 - 3 - 0 ..... Asynchronous counter using JK flip flops
module jk(input clk, rst, j, k, output reg q);
    always @(negedge clk or posedge rst) begin //negedge because of this specific pattern
        if(rst) q <= 1'b0;
        else begin
            case({j,k})
                2'b00: q <= q;        // No change
                2'b01: q <= 1'b0;     // Reset
                2'b10: q <= 1'b1;     // Set
                2'b11: q <= ~q;       // Toggle
            endcase
        end
    end
endmodule

module counter1(input clk, rst, output [1:0]Q);
    assign reset = rst | (Q[2] & Q[1] & Q[0]); //for this to work correctly, rst used in jkff should be asynchronous
    jk j1(clk, reset, 1'b1, 1'b1, Q[2]);
    jk j2(Q[2], reset, 1'b1, 1'b1, Q[1]);
    jk j3(Q[1], reset, 1'b1, 1'b1, Q[0]);
endmodule

/*
// BCD Counter
module counter2(input clk, rst, output [3:0]Q);
    wire J;
    assign J = (~Q[3] & Q[2] & Q[1]) | (Q[3] & ~Q[2] & ~Q[1]);
    jk j1(clk, rst, 1'b1, 1'b1, Q[0]);
    jk j2(Q[0], rst, ~Q[3], 1'b1, Q[1]);
    jk j3(Q[1], rst, 1'b1, 1'b1, Q[2]);
    jk j4(Q[0], rst, J, 1'b1, Q[3]);
endmodule
*/
/*
// 2 - 3 - 5 - 7 - 11 - 13 - 2 ....... Asynchronous counter using JK flip flops
module counter3(input clk, rst, output [3:0]Q);
    wire K1;
    assign K1 = (~Q[3] & ~Q[2] & Q[1] & ~Q[0]) | (Q[3] & Q[2] & ~Q[1] & Q[0])
    jk j1(clk, rst, 1'b1, K1, Q[0]);
    jk j2();
    jk j3();
    jk j4(Q[2], rst, 1'b1, 1'b1, Q[3]);
endmodule
*/ //is it possible to do it like this?