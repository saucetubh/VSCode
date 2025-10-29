//counter that does both up and down - mode decided by input
module jkfflop(input  J, K , clk ,rst, mode, output reg Q);
    always @(negedge clk or posedge rst) begin 
        if(rst) begin
            Q <= mode ? 1'b1 : 1'b0; //if mode is 1 (down counting) reset to 1 else reset to 0 //if using M-2 then simply do Q <= 1'b0;
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

module BCD_Counter(input clk, rst, mode, output [3:0] Q);

    wire [3:0] T;
    jkfflop j1(1'b1 ,1'b1, clk, rst, mode, T[0]);
    jkfflop j2(1'b1, 1'b1, (mode ? ~T[0] : T[0]), rst, mode, T[1]); //if mode is 1 then down counter
    jkfflop j3(1'b1, 1'b1, (mode ? ~T[1] : T[1]), rst, mode, T[2]);
    jkfflop j4(1'b1, 1'b1, (mode ? ~T[2] : T[2]), rst, mode, T[3]);
    assign Q = {T[3], T[2], T[1], T[0]};

/* //M2
    wire [3:0] T;
    jkfflop j1(1'b1 ,1'b1, clk, rst, mode, T[0]);
    jkfflop j2(1'b1, 1'b1, T[0], rst, mode, T[1]); //if mode is 1 then down counter
    jkfflop j3(1'b1, 1'b1, T[1], rst, mode, T[2]);
    jkfflop j4(1'b1, 1'b1, T[2], rst, mode, T[3]);
    assign Q = (!mode) ? {T[3], T[2], T[1], T[0]} : {~T[3], ~T[2], ~T[1], ~T[0]};
*/
endmodule

//small issue in both implementation, look at output
//to avoid this gemini says use synchronous 