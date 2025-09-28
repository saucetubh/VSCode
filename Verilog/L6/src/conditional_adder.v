module conditional_adder (
    input  [8:0] X,
    input  [1:0] SEL,
    output reg [8:0] Y
);
    always @(*) begin
        case(SEL)
            2'b00: Y=X+1;
            2'b01: Y=X+3;
            2'b10: Y=X+2;
            2'b11: Y=X+4;
        endcase
    end
endmodule
