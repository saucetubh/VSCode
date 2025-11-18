
`include "q1.v"
`include "q2.v"
`include "q3.v"

module top_module(
    input clk, rst, ctrl, 
    input [3:0]num1, //initial number to load in shift reg 1
    input [3:0]num2, //initital number to load in shift reg 2
    output [3:0]out1, //stores current contents of shift reg 1
    output [3:0]out2, //stores current contents of shift reg 2
    output sum //sum of full adder
);
    Shiftreg s1(clk, rst, ctrl, sum, num1, out1);
    Shiftreg s2(clk, rst, ctrl, 1'b0, num2, out2);
    wire cin, cout;
    DFF d1(cout, clk, rst, cin);
    FA f1(out1[0], out2[0], cin, sum, cout);
endmodule


/*
`include "q1.v"
`include "q2.v"
`include "q3.v"

module top_module(
    input wire clk,
    input wire rst,
    input wire ctrl,
    input wire [3:0] num1, //initial number to load in shift reg 1
    input wire [3:0] num2, //initial number to load in shift reg 2
    output wire [3:0] out1,//stores current content of first shift reg
    output wire [3:0] out2,//stores current content of second shift reg
    output wire sum// sum of full adder
);

wire Cin;
wire Cout;

Shiftreg s1(clk, rst, sum, ctrl, num1, out1);
Shiftreg s2(clk, rst, 1'b0, ctrl, num2, out2);

DFF d1(clk, rst, Cout, Cin);

FA f1(out1[0], out2[0], Cin, sum, Cout);

endmodule

// `include "Dff.v"
// `include "FullAdder.v"
// `include "ShiftReg.v"

// module top_module(
//     input wire clk,
//     input wire rst,
//     input wire ctrl,
//     input wire [3:0] num1,
//     input wire [3:0] num2,
//     output wire [3:0] out1,
//     output wire [3:0] out2,
//     output wire sum
// );

//     wire a3;
//     wire D, Q;

//     // Generate clock control signal
//     and(a3, clk, ctrl);

//     // Instantiate D flip-flop, Shift registers, and Full adder
//     Dff df(a3, rst, D, Q);
//     Shiftreg rg1(clk, rst, sum, ctrl, num1, out1);
//     Shiftreg rg2(clk, rst, 1'b0, ctrl, num2, out2);
//     Fulladder f1(out1[0], out2[0], Q, sum, D);

// endmodule
*/