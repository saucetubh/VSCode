`include "fa.v"
`include "usr.v"
`include "dff.v"

module sa(input clk, clr, input [3:0]A, input [3:0]B, output [3:0]S, output carry);
    wire [3:0]A_reg;
    wire [3:0]B_reg;
    wire s, cin, cout;
    fa f1(A_reg[0], B_reg[0], cin, s, cout);
    dff d1(clk, clr, cout, cin);
    usr u1(clk, clr, s, 1'b0, 2'b01, 4'b0000, A, A_reg);
    usr u2(clk, clr, 1'b0, 1'b0, 2'b01, 4'b0000, B, B_reg);
    assign S = A_reg;
    assign carry = cin; //should this be cout or cin?
    /*
    wire [3:0]A_reg;
    wire [3:0]B_reg;
    wire s, cin, cout;
    fa f1(A_reg[0], B_reg[0], cin, s, cout);
    dff d1(clk, clr, cout, cin);
    usr u1(clk, clr, A_reg[0], 1'b0, 2'b01, 4'b0000, A, A_reg);
    usr u2(clk, clr, B_reg[0], 1'b0, 2'b01, 4'b0000, B, B_reg);
    usr u3(clk, clr, s, 1'b0, 2'b01, 4'b0000, 4'b0000, S); 
    assign carry = cout; //should this be cout or cin?
    */
endmodule 