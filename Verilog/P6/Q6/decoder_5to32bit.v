module decoder_5to32(input [4:0] in, output reg [31:0] out);
always @(*) begin
  out = 32'b0; //it is important to initialize this inside the always block, else it will retain previous values when input changes 
  out[in] = 1'b1;
  //out = 32'b1 << in; //Another method
end
endmodule

