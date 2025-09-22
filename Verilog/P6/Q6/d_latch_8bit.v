module d_latch_8bit(input [7:0] d, input en, output reg [7:0] q);
  always @(*) begin
    if(en) begin
      q=d;
    end
  end
endmodule
