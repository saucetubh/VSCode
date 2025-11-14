`include "q1.v"
`include "q2.v"
`include "q3.v"

module top_module(
    input clk, rst, ctrl, 
    input [3:0]num1, //initial number to load in shift reg 1
    input [3:0]num2, //initital number to load in shift reg 2
    output [3:0]out1, //stores current contents of shift reg 1
    output [3:0]out2, //stores current contents of shift reg 2
    output s //sum of full adder
);
    Shiftreg s1(clk, rst, ctrl, sum, num1, out1);
    Shiftreg s2(clk, rst, ctrl, 1'b0, num2, out2);
    wire cin, cout;
    DFF d1(cout, clk, rst, cin);
    FA f1(out1[0], out2[0], cin, sum, cout);
endmodule