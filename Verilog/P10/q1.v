module jkfflop(input  J, K , clk ,rst, output reg Q);
    always @(negedge clk or posedge rst) begin //only works with negedge clk, with posedge clk gives all 0s, why?
    //because posedge clk is for down counter and negedge clk is for up counter
        if(rst) begin
            Q <= 1'b0;
        end
        else begin
            case({J,K})
                2'b01: Q <= 1'b0;
                2'b10: Q <= 1'b1;
                2'b11: Q <= ~Q;
            endcase
        end
    end
endmodule
//asynchronous BCD Counter -- for some reason works only when i take a posedge rst, does not work with negedge rst or synchronous rst -- WHY?
//with negedge rst use !rst (active low) and change logic to (rst & ~(Q[1] & Q[3])) and vice versa for posedge rst
//why does it not work with synchronous rst? - idk - could be race condition?

module BCD_Counter(input clk, rst, output [3:0] Q);
    jkfflop j1(1'b1 ,1'b1, clk, (rst |(Q[1] & Q[3])), Q[0]); //checks for state 1010 i.e the next state after 1001
    jkfflop j2(1'b1, 1'b1, Q[0], (rst |(Q[1] & Q[3])), Q[1]);
    jkfflop j3(1'b1, 1'b1, Q[1], (rst |(Q[1] & Q[3])), Q[2]);
    jkfflop j4(1'b1, 1'b1, Q[2], (rst |(Q[1] & Q[3])), Q[3]); //can pass Q bar as clk and use posedge clk in flip flop or pass Q as clock and use negedge clk in flip flop

//synchronous BCD Counter 
/*
module BCD_Counter(input clk, rst, output [3:0] Q);
    jkfflop j1(1'b1, 1'b1, clk, rst, Q[0]);
    jkfflop j2((Q[0]&~Q[3]), Q[0], clk, rst, Q[1]);
    jkfflop j3((Q[0]&Q[1]), (Q[0]&Q[1]), clk, rst, Q[2]);
    jkfflop j4((Q[2]&Q[1]&Q[0]), Q[0], clk, rst, Q[3]);
*/
/* 
assign J0 = 1'b1;
assign K0 = 1'b1;
assign J1 = Q[0] & ~Q[3];
assign K1 = Q[0];
assign J2 = Q[0] & Q[1];
assign K2 = Q[0] & Q[1];
assign J3 = Q[2] & Q[1] & Q[0];
assign K3 = Q[0];
jkfflop j0(J0, K0, clk, rst, Q[0]);
jkfflop j1(J1, K1, clk, rst, Q[1]);
jkfflop j2(J2, K2, clk, rst, Q[2]);
jkfflop j3(J3, K3, clk, rst, Q[3]);
*/
endmodule

//NOTE
/*
With asynchronous counters, use asynchronous reset. If active high reset then posedge reset, if active low then negedge reset.
With synchronous counters, use synchronous reset. If active high reset then just reset, if active low then !reset.
With asynchronous counters, if upcounter the use negedge clk, if downcounter use posedge clk.
With synchronous counters, it doesnt matter. However, do what the testbench assumes. 
*/