//-ve edge triggered flip flop with active high asynchronous clear for asynchronous up counter
module dff(input clk, clr, d, output reg q);
    always @(negedge clk or posedge clr) begin
        if(clr) q<=1'b0;
        else q<=d;   
    end
endmodule
//mod 6 counter 
module rep(input clk, input clr, output [2:0]C);
    dff d1(clk, clr|(C[2]&C[1]), ~C[0], C[0]);
    dff d2(C[0], clr|(C[2]&C[1]), ~C[1], C[1]);
    dff d3(C[1], clr|(C[2]&C[1]), ~C[2], C[2]);
endmodule
//mapping module
module map(input [2:0]C, output reg [1:0]O);
    always @(*) begin
        case(C)
            3'b000: O=2'b00;
            3'b001: O=2'b00;
            3'b010: O=2'b01;
            3'b011: O=2'b10;
            3'b100: O=2'b10;
            3'b101: O=2'b11;
        endcase
    end
endmodule

module top(input clk, input clr, output [1:0]O);
    wire [2:0]C;
    rep r0(clk, clr, C);
    map m0(C, O);
endmodule
//can also implement this using a moore machine type synch counter (from 0to5) and each state corresponds to the pattern output
//instead of having the last two modules, can simply do this as well
/*
module rep(input clk, input clr, output [1:0]O);
    wire [2:0]C;
    dff d1(clk, clr|(C[2]&C[1]), ~C[0], C[0]);
    dff d2(C[0], clr|(C[2]&C[1]), ~C[1], C[1]);
    dff d3(C[1], clr|(C[2]&C[1]), ~C[2], C[2]);
    always @(*) begin
        case(C)
            3'b000: O=2'b00;
            3'b001: O=2'b00;
            3'b010: O=2'b01;
            3'b011: O=2'b10;
            3'b100: O=2'b10;
            3'b101: O=2'b11;
        endcase
    end
endmodule
*/