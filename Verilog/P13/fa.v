module fa( input a, input b, input cin, output reg sum, output reg cout );
    always @(*) begin
        {cout, sum} = a + b + cin;
    end
endmodule