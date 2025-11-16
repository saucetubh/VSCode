module mux21(input [1:0]I, input S, input En, output /*reg*/ Y);
    /*
    always @(*) begin
        case(S)
            1'b0: Y = En&I[0];
            1'b1: Y = En&I[1];
        endcase
    end 
    */
    assign Y = En & ((S & I[1]) | (~S & I[0]));
endmodule

module mux41(input [3:0]I, input [1:0]S, input En, output Y);
    wire Y1, Y2;
    mux21 m1(I[3:2], S[0], En&S[1], Y2);
    mux21 m2(I[1:0], S[0], En&~S[1], Y1);
    assign Y = Y1|Y2;
endmodule

module mux81(input [7:0]I, input [2:0]S, input En, output Y);
    wire Y1, Y2;
    mux41 m1(I[7:4], S[1:0], En&S[2], Y2);
    mux41 m2(I[3:0], S[1:0], En&~S[2], Y1);
    assign Y = Y2|Y1;
endmodule