module D_ff(input clk, input chipSelect, input reset, input regWrite, input enable, input d, output reg q);
    always @(posedge clk) begin
        if(reset && chipSelect) q<=1'b0;
        else if(chipSelect && enable && regWrite) q<=d;
    end
endmodule

module mux2to1_16bits(input [15:0] in0, input [15:0] in1, input select, output reg [15:0] muxOut);
    always @(*) begin
        case(select)
            1'b0: muxOut = in0;
            1'b1: muxOut = in1;
        endcase
    end
endmodule

module decoder5to32(input [4:0] selectIn, output reg [31:0] decOut);
    always @(*) begin
        decOut = 32'b0;
        decOut[selectIn] = 1'b1;
    end
endmodule

module register16bit(input clk, input chipSelect, input reset, input regWrite, input enable, input [15:0] inR, output reg [15:0] outR);
    genvar i;
    generate 
        for(i=0; i<16; i=i+1) begin: reg_loop
            D_ff dff(clk, chipSelect, reset, regWrite, enable, inR[i], outR[i]);
        end
    endgenerate
endmodule

module mux32to1(input [15:0] in0, input [15:0] in1, input [15:0] in2, input [15:0] in3, input [15:0] in4, input [15:0] in5, input [15:0] in6, input [15:0] in7,
                 input [15:0] in8, input [15:0] in9, input [15:0] in10, input [15:0] in11, input [15:0] in12, input [15:0] in13, input [15:0] in14, input [15:0] in15,
                 input [15:0] in16, input [15:0] in17, input [15:0] in18, input [15:0] in19, input [15:0] in20, input [15:0] in21, input [15:0] in22, input [15:0] in23,
                 input [15:0] in24, input [15:0] in25, input [15:0] in26, input [15:0] in27, input [15:0] in28, input [15:0] in29, input [15:0] in30, input [15:0] in31,
                 input [4:0] selectIn, output reg [15:0] muxOut);
    always @(*) begin
        case(selectIn)
            5'b00000 : muxOut = in0;
            5'b00001 : muxOut = in1;
            5'b00010 : muxOut = in2;
            5'b00011 : muxOut = in3;
            5'b00100 : muxOut = in4;
            5'b00101 : muxOut = in5;
            5'b00110 : muxOut = in6;
            5'b00111 : muxOut = in7;
            5'b01000 : muxOut = in8;
            5'b01001 : muxOut = in9;
            5'b01010 : muxOut = in10;
            5'b01011 : muxOut = in11;
            5'b01100 : muxOut = in12;
            5'b01101 : muxOut = in13;
            5'b01110 : muxOut = in14;
            5'b01111 : muxOut = in15;
            5'b10000 : muxOut = in16;
            5'b10001 : muxOut = in17;
            5'b10010 : muxOut = in18;
            5'b10011 : muxOut = in19;
            5'b10100 : muxOut = in20;
            5'b10101 : muxOut = in21;
            5'b10110 : muxOut = in22;
            5'b10111 : muxOut = in23;
            5'b11000 : muxOut = in24;
            5'b11001 : muxOut = in25;
            5'b11010 : muxOut = in26;
            5'b11011 : muxOut = in27;
            5'b11100 : muxOut = in28;
            5'b11101 : muxOut = in29;
            5'b11110 : muxOut = in30;
            5'b11111 : muxOut = in31;
        endcase
    end
endmodule

module ram32byte(input clk, input chipSelect, input reset, input outputEnable, input writeEnable, input [4:0] address, input [15:0] writeData, output reg [15:0] memOut);
    reg [31:0] decoded_address;
    decoder5to32 dec(address, decoded_address);
    reg [15:0] mem [0:31];
    genvar i;
    generate 
        for(i=0;i<32;i=i+1) begin: ram_loop
            register16bit reg(clk, chipSelect, reset, writeEnable, decoded_address[i], writeData, mem[i]);
        end
    endgenerate
    reg [15:0] muxOut;
    mux32to1 read_mux(mem[0], mem[1], mem[2], mem[3], mem[4], mem[5], mem[6], mem[7],
                 mem[8], mem[9], mem[10], mem[11], mem[12], mem[13], mem[14], mem[15],
                 mem[16], mem[17], mem[18], mem[19], mem[20], mem[21], mem[22], mem[23],
                 mem[24], mem[25], mem[26], mem[27], mem[28], mem[29], mem[30], mem[31],
                 address, muxOut);
    mux2to1_16bits output_mux(16'b0, muxOut, outputEnable & chipSelect, memOut);
endmodule

module rom32byte(input chipSelect, input outputEnable, input [4:0] address, output reg [15:0] dataOut);
    reg [15:0] mem [0:31];
    initial begin
        mem[0] = 16'h0001;
        mem[1] = 16'h0002;
        mem[2] = 16'h0003;
        mem[3] = 16'h0004;
        mem[4] = 16'h0005;
        mem[5] = 16'h0006;
        mem[6] = 16'h0007;
        mem[7] = 16'h0008;
        mem[8] = 16'h0009;
        mem[9] = 16'h000A;
        mem[10] = 16'h000B;
        mem[11] = 16'h000C;
        mem[12] = 16'h000D;
        mem[13] = 16'h000E;
        mem[14] = 16'h000F;
        mem[15] = 16'h0010;
        mem[16] = 16'h0011;
        mem[17] = 16'h0012;
        mem[18] = 16'h0013;
        mem[19] = 16'h0014;
        mem[20] = 16'h0015;
        mem[21] = 16'h0016;
        mem[22] = 16'h0017;
        mem[23] = 16'h0018;
        mem[24] = 16'h0019;
        mem[25] = 16'h001A;
        mem[26] = 16'h001B;
        mem[27] = 16'h001C;
        mem[28] = 16'h001D;
        mem[29] = 16'h001E;
        mem[30] = 16'h001F;
        mem[31] = 16'h0020; 
    end
    always @(*) begin
        if(chipSelect && outputEnable) dataOut=mem[address];
        else dataOut=16'b0;
    end
endmodule

module ram1kb(input clk, input chipSelect, input reset, input outputEnable, input writeEnable, input [9:0] address, input [15:0] writeData, output reg [15:0] memOut);
    reg [31:0] chip_address;
    decoder5to32 dec(address[9:5], chip_address);
    reg [15:0] chips [0:31];
    genvar i;
    generate 
        for(i=0;i<32;i=i+1) begin : chip_loop
            ram32byte ram(clk, chipSelect & chip_address[i], reset, outputEnable, writeEnable, address[4:0], writeData, chips[i]);
        end
    endgenerate
    mux32to1 read_mux(chips[0], chips[1], chips[2], chips[3], chips[4], chips[5], chips[6], chips[7],
                 chips[8], chips[9], chips[10], chips[11], chips[12], chips[13], chips[14], chips[15],
                 chips[16], chips[17], chips[18], chips[19], chips[20], chips[21], chips[22], chips[23],
                 chips[24], chips[25], chips[26], chips[27], chips[28], chips[29], chips[30], chips[31],
                 address[9:5], memOut);
endmodule

module rom1kb(input chipSelect, input outputEnable, input [9:0] address, output reg [15:0] dataOut);
    reg [31:0] chip_address;
    decoder5to32 dec(address[9:5], chip_address); 
    reg [15:0] chips [0:31];
    genvar i;
    generate
        for(i=0;i<32;i=i+1) begin : rom_loop
            rom32byte rom(chipSelect & chip_address[i], outputEnable, address[4:0], chips[i]);
        end
    endgenerate
    mux32to1 read_mux(chips[0], chips[1], chips[2], chips[3], chips[4], chips[5], chips[6], chips[7],
                 chips[8], chips[9], chips[10], chips[11], chips[12], chips[13], chips[14], chips[15],
                 chips[16], chips[17], chips[18], chips[19], chips[20], chips[21], chips[22], chips[23],
                 chips[24], chips[25], chips[26], chips[27], chips[28], chips[29], chips[30], chips[31],
                 address[9:5], dataOut);
endmodule

module memory_system(input clk, input reset, input [19:0] address, input RD_n, input WR_n, input M_IO_n, output [15:0] data_out);
    wire ram_cs = ~M_IO_n & (address[19:10] == 10'h000);
    wire rom_cs = ~M_IO_n & (address[19:10] == 10'h001);
    wire [15:0] ram_out;
    wire [15:0] rom_out;
    ram1kb ram(clk, ram_cs, reset, ~RD_n, ~WR_n, address[9:0], 16'b0, ram_out);
    rom1kb rom(rom_cs, ~RD_n, address[9:0], rom_out);
    assign data_out = ram_cs ? ram_out : (rom_cs ? rom_out : 16'b0);
endmodule