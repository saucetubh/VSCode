module fulladder(input A, input B, input Cin, output reg Cout, output reg Sum);
    always @(*) begin 
        {Cout, Sum} = A + B + Cin;
    end
endmodule