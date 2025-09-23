module bit_intel_extractor(input [7:0] in, output reg [2:0] intel_score); //since output is reg, implies we will store values procedurally, procedural assignment. Wire->contiuous assignment
  always @(*) begin
      intel_score[0] = in[7] & in[6];
      intel_score[1] = in[5] ^ in[4];
      intel_score[2] = in[3] | in[2];
      //or o1(intel_score[2], in[3], in[2]); //will not work since gates used continuous assignment, not allowed inside always block
  end
  //assign intel_score[0] = in[7] ~^ in[6]; //will not work since intel_score is reg
endmodule
