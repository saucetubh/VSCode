module mux4_1 (input a, input b, input c,input d, input[1:0] select, output reg out); //a corresponds to 0th bit i.e LSB
    always @(*) begin
        case (select)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
        endcase
    end
endmodule
//this is a 4 to 1 multiplexer module with 4 inputs (a, b, c, d), a 2-bit select line, and one output (out).
//if select is 00, out = a (LSB)