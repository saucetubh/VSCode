module full_adder_4bit (
    input  [3:0] A, B,
    output reg [3:0] S
);
    always @(*) begin
        S=A+B;
    end
endmodule
