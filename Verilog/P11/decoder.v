module dec12(input I, input En, output /*reg*/ [1:0]O);
    /*
    always @(*) begin
        if(I) O = 2'b10;
        else O = 2'b01;
    end
    */
    assign O = {En&I, En&~I}; //active high enable
endmodule

module dec24(input [1:0]I, input En, output [3:0]O);
    dec12 d1(I[0], En&I[1], O[3:2]);
    dec12 d2(I[0], En&~I[1], O[1:0]);
endmodule

module dec38(input [3:0]I, input En, output [7:0]O);
    dec24 d1(I[1:0], En&I[2], O[7:4]);
    dec24 d2(I[1:0], En&~I[2], O[3:0]);
endmodule