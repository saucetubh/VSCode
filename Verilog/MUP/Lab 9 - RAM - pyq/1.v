module D_ff(clk, chipSelect, reset, regWrite, enable, d, q);
input clk, chipSelect, reset, regWrite, enable, d;
output reg q;

always @(posedge clk) begin
if (chipSelect) begin
if (reset)
q <= 0;
else if (enable && regWrite)
q <= d;
end
end
endmodule

module mux2to1_16bits(in0, in1, select, muxOut);
input [15:0] in0, in1;
input select;
output [15:0] muxOut;

assign muxOut = select ? in1 : in0;
endmodule

module decoder4to16(destReg, decOut);
input [3:0] destReg;
output reg [15:0] decOut;

always @(*) begin
decOut = 16'b0;
decOut[destReg] = 1'b1;
end
endmodule

module register8bit(clk, chipSelect, reset, regWrite, enable, inR, outR);
input clk, chipSelect, reset, regWrite, enable;
input [7:0] inR;
output [7:0] outR;

D_ff ff0(clk, chipSelect, reset, regWrite, enable, inR[0], outR[0]);
D_ff ff1(clk, chipSelect, reset, regWrite, enable, inR[1], outR[1]);
D_ff ff2(clk, chipSelect, reset, regWrite, enable, inR[2], outR[2]);
D_ff ff3(clk, chipSelect, reset, regWrite, enable, inR[3], outR[3]);
D_ff ff4(clk, chipSelect, reset, regWrite, enable, inR[4], outR[4]);
D_ff ff5(clk, chipSelect, reset, regWrite, enable, inR[5], outR[5]);
D_ff ff6(clk, chipSelect, reset, regWrite, enable, inR[6], outR[6]);
D_ff ff7(clk, chipSelect, reset, regWrite, enable, inR[7], outR[7]);
endmodule

module mux32to2(
in0, in1, in2, in3, in4, in5, in6, in7,
in8, in9, in10, in11, in12, in13, in14, in15,
in16, in17, in18, in19, in20, in21, in22, in23,
in24, in25, in26, in27, in28, in29, in30, in31,
select, muxOut
);
input [7:0] in0, in1, in2, in3, in4, in5, in6, in7;
input [7:0] in8, in9, in10, in11, in12, in13, in14, in15;
input [7:0] in16, in17, in18, in19, in20, in21, in22, in23;
input [7:0] in24, in25, in26, in27, in28, in29, in30, in31;
input [3:0] select;
output reg [15:0] muxOut;

wire [7:0] mem [0:31];
assign mem[0] = in0; assign mem[1] = in1;
assign mem[2] = in2; assign mem[3] = in3;
assign mem[4] = in4; assign mem[5] = in5;
assign mem[6] = in6; assign mem[7] = in7;
assign mem[8] = in8; assign mem[9] = in9;
assign mem[10] = in10; assign mem[11] = in11;
assign mem[12] = in12; assign mem[13] = in13;
assign mem[14] = in14; assign mem[15] = in15;
assign mem[16] = in16; assign mem[17] = in17;
assign mem[18] = in18; assign mem[19] = in19;
assign mem[20] = in20; assign mem[21] = in21;
assign mem[22] = in22; assign mem[23] = in23;
assign mem[24] = in24; assign mem[25] = in25;
assign mem[26] = in26; assign mem[27] = in27;
assign mem[28] = in28; assign mem[29] = in29;
assign mem[30] = in30; assign mem[31] = in31;

always @(*) begin
muxOut = {mem[2*select], mem[2*select + 1]};
end
endmodule

module ram(clk, chipSelect, reset, outputEnable, writeEnable, address, writeData, memOut);
input clk, chipSelect, reset, outputEnable, writeEnable;
input [3:0] address;
input [15:0] writeData;
output [15:0] memOut;

wire [15:0] decOut;
wire [7:0] regOut [0:31];

decoder4to16 dec(address, decOut);

genvar i;
generate
for (i = 0; i < 16; i = i + 1) begin : mem_gen
register8bit regH(
clk, chipSelect, reset, writeEnable, decOut[i],
writeData[15:8], regOut[2*i]
);
register8bit regL(
clk, chipSelect, reset, writeEnable, decOut[i],
writeData[7:0], regOut[2*i+1]
);
end
endgenerate

wire [15:0] muxResult;
mux32to2 readMux(
regOut[0], regOut[1], regOut[2], regOut[3],
regOut[4], regOut[5], regOut[6], regOut[7],
regOut[8], regOut[9], regOut[10], regOut[11],
regOut[12], regOut[13], regOut[14], regOut[15],
regOut[16], regOut[17], regOut[18], regOut[19],
regOut[20], regOut[21], regOut[22], regOut[23],
regOut[24], regOut[25], regOut[26], regOut[27],
regOut[28], regOut[29], regOut[30], regOut[31],
address, muxResult
);

mux2to1_16bits outMux(16'b0, muxResult, outputEnable, memOut);

endmodule