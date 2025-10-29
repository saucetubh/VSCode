module jkfflop(input  J, K , clk ,rst, output reg Q);
    always @(negedge clk or posedge rst) begin //notice the difference
        if(rst) begin
            Q <= 1'b1; //notice the difference
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

module BCD_Counter(input clk, rst, output [3:0] Q);

    wire [3:0] T;
    jkfflop j1(1'b1 ,1'b1, clk, (rst |(~T[1] & ~T[2])), T[0]); //notice the difference
    jkfflop j2(1'b1, 1'b1, ~T[0], (rst |(~T[1] & ~T[2])), T[1]);
    jkfflop j3(1'b1, 1'b1, ~T[1], (rst |(~T[1] & ~T[2])), T[2]);
    jkfflop j4(1'b1, 1'b1, ~T[2], (rst |(~T[1] & ~T[2])), T[3]);
    assign Q = {T[3], T[2], T[1], T[0]}; 

//OR 
/*
    wire [3:0] T;
    jkfflop j1(1'b1 ,1'b1, clk, (rst | (T[1]&T[2])), T[0]); //why does this new condition not work?
    jkfflop j2(1'b1, 1'b1, T[0], (rst | (T[1]&T[2])), T[1]);
    jkfflop j3(1'b1, 1'b1, T[1], (rst | (T[1]&T[2])), T[2]);
    jkfflop j4(1'b1, 1'b1, T[2], (rst | (T[1]&T[2])), T[3]);
    assign Q = {~T[3], ~T[2], ~T[1], ~T[0]}; 
*/
endmodule

//test this with q1_tb.v
//this is asynchronous down counter that counts from 15 to 10 and then goes back to 15 again


//NOTE - 
/*
For an asynchronous down counter, either you can use posedge clk and use Q as clk of the next flip flop
OR you can use negedge clk and use ~Q as clk of the next flip flop.
Similar logic for upcounter also.
OR you can use negedge clk and use Q as clk of the next flip flop BUT use Qbar as the output for each flip flop  -- it works, try figuring out what the new condition should be for reset
output of first flip flop will be LSB
*/