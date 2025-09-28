module halfadder(input A, input B, output reg Cout, output reg Sum);
    always @(*) begin
        {Cout, Sum} = A + B;
    end
endmodule