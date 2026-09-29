/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

// Register File Starts

module Dff_RF(input clk, input reset, input regWrite, input decOut1b , input d, output reg q);
      always @ (posedge clk)
    begin
        if(reset == 1'b1)
        begin
            q <= 0;
        end
        else if(regWrite == 1'b1 && decOut1b == 1'b1)
        begin
            q <= d;
        end
    end
endmodule

module register32bit(input clk, input reset, input regWrite, input decOut1b, input [31:0] inR, 
                     output [31:0] outR);
    Dff_RF d0  (clk, reset, regWrite, decOut1b, inR[0],  outR[0]);
    Dff_RF d1  (clk, reset, regWrite, decOut1b, inR[1],  outR[1]);
    Dff_RF d2  (clk, reset, regWrite, decOut1b, inR[2],  outR[2]);
    Dff_RF d3  (clk, reset, regWrite, decOut1b, inR[3],  outR[3]);
    Dff_RF d4  (clk, reset, regWrite, decOut1b, inR[4],  outR[4]);
    Dff_RF d5  (clk, reset, regWrite, decOut1b, inR[5],  outR[5]);
    Dff_RF d6  (clk, reset, regWrite, decOut1b, inR[6],  outR[6]);
    Dff_RF d7  (clk, reset, regWrite, decOut1b, inR[7],  outR[7]);
    Dff_RF d8  (clk, reset, regWrite, decOut1b, inR[8],  outR[8]);
    Dff_RF d9  (clk, reset, regWrite, decOut1b, inR[9],  outR[9]);
    Dff_RF d10 (clk, reset, regWrite, decOut1b, inR[10], outR[10]);
    Dff_RF d11 (clk, reset, regWrite, decOut1b, inR[11], outR[11]);
    Dff_RF d12 (clk, reset, regWrite, decOut1b, inR[12], outR[12]);
    Dff_RF d13 (clk, reset, regWrite, decOut1b, inR[13], outR[13]);
    Dff_RF d14 (clk, reset, regWrite, decOut1b, inR[14], outR[14]);
    Dff_RF d15 (clk, reset, regWrite, decOut1b, inR[15], outR[15]);
    Dff_RF d16 (clk, reset, regWrite, decOut1b, inR[16], outR[16]);
    Dff_RF d17 (clk, reset, regWrite, decOut1b, inR[17], outR[17]);
    Dff_RF d18 (clk, reset, regWrite, decOut1b, inR[18], outR[18]);
    Dff_RF d19 (clk, reset, regWrite, decOut1b, inR[19], outR[19]);
    Dff_RF d20 (clk, reset, regWrite, decOut1b, inR[20], outR[20]);
    Dff_RF d21 (clk, reset, regWrite, decOut1b, inR[21], outR[21]);
    Dff_RF d22 (clk, reset, regWrite, decOut1b, inR[22], outR[22]);
    Dff_RF d23 (clk, reset, regWrite, decOut1b, inR[23], outR[23]);
    Dff_RF d24 (clk, reset, regWrite, decOut1b, inR[24], outR[24]);
    Dff_RF d25 (clk, reset, regWrite, decOut1b, inR[25], outR[25]);
    Dff_RF d26 (clk, reset, regWrite, decOut1b, inR[26], outR[26]);
    Dff_RF d27 (clk, reset, regWrite, decOut1b, inR[27], outR[27]);
    Dff_RF d28 (clk, reset, regWrite, decOut1b, inR[28], outR[28]);
    Dff_RF d29 (clk, reset, regWrite, decOut1b, inR[29], outR[29]);
    Dff_RF d30 (clk, reset, regWrite, decOut1b, inR[30], outR[30]);
    Dff_RF d31 (clk, reset, regWrite, decOut1b, inR[31], outR[31]);
endmodule

// Note: r0 in MIPS is always 0
module registerSet(input clk, input reset, input regWrite, input [31:0] decOut, input [31:0] writeData,
                   output [31:0] outR0,  output [31:0] outR1,  output [31:0] outR2,  output [31:0] outR3,
                   output [31:0] outR4,  output [31:0] outR5,  output [31:0] outR6,  output [31:0] outR7,
                   output [31:0] outR8,  output [31:0] outR9,  output [31:0] outR10, output [31:0] outR11,
                   output [31:0] outR12, output [31:0] outR13, output [31:0] outR14, output [31:0] outR15,
                   output [31:0] outR16, output [31:0] outR17, output [31:0] outR18, output [31:0] outR19,
                   output [31:0] outR20, output [31:0] outR21, output [31:0] outR22, output [31:0] outR23,
                   output [31:0] outR24, output [31:0] outR25, output [31:0] outR26, output [31:0] outR27,
                   output [31:0] outR28, output [31:0] outR29, output [31:0] outR30, output [31:0] outR31);
    register32bit r0  (clk, reset, regWrite, decOut[0],  32'b0, outR0);
    register32bit r1  (clk, reset, regWrite, decOut[1],  writeData, outR1);
    register32bit r2  (clk, reset, regWrite, decOut[2],  writeData, outR2);
    register32bit r3  (clk, reset, regWrite, decOut[3],  writeData, outR3);
    register32bit r4  (clk, reset, regWrite, decOut[4],  writeData, outR4);
    register32bit r5  (clk, reset, regWrite, decOut[5],  writeData, outR5);
    register32bit r6  (clk, reset, regWrite, decOut[6],  writeData, outR6);
    register32bit r7  (clk, reset, regWrite, decOut[7],  writeData, outR7);
    register32bit r8  (clk, reset, regWrite, decOut[8],  writeData, outR8);
    register32bit r9  (clk, reset, regWrite, decOut[9],  writeData, outR9);
    register32bit r10 (clk, reset, regWrite, decOut[10], writeData, outR10);
    register32bit r11 (clk, reset, regWrite, decOut[11], writeData, outR11);
    register32bit r12 (clk, reset, regWrite, decOut[12], writeData, outR12);
    register32bit r13 (clk, reset, regWrite, decOut[13], writeData, outR13);
    register32bit r14 (clk, reset, regWrite, decOut[14], writeData, outR14);
    register32bit r15 (clk, reset, regWrite, decOut[15], writeData, outR15);
    register32bit r16 (clk, reset, regWrite, decOut[16], writeData, outR16);
    register32bit r17 (clk, reset, regWrite, decOut[17], writeData, outR17);
    register32bit r18 (clk, reset, regWrite, decOut[18], writeData, outR18);
    register32bit r19 (clk, reset, regWrite, decOut[19], writeData, outR19);
    register32bit r20 (clk, reset, regWrite, decOut[20], writeData, outR20);
    register32bit r21 (clk, reset, regWrite, decOut[21], writeData, outR21);
    register32bit r22 (clk, reset, regWrite, decOut[22], writeData, outR22);
    register32bit r23 (clk, reset, regWrite, decOut[23], writeData, outR23);
    register32bit r24 (clk, reset, regWrite, decOut[24], writeData, outR24);
    register32bit r25 (clk, reset, regWrite, decOut[25], writeData, outR25);
    register32bit r26 (clk, reset, regWrite, decOut[26], writeData, outR26);
    register32bit r27 (clk, reset, regWrite, decOut[27], writeData, outR27);
    register32bit r28 (clk, reset, regWrite, decOut[28], writeData, outR28);
    register32bit r29 (clk, reset, regWrite, decOut[29], writeData, outR29);
    register32bit r30 (clk, reset, regWrite, decOut[30], writeData, outR30);
    register32bit r31 (clk, reset, regWrite, decOut[31], writeData, outR31);
endmodule

module decoder5to32(input [4:0] destReg, output reg [31:0] decOut);
    always@(destReg)
    begin
        case(destReg)
            5'd0:  decOut = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
            5'd1:  decOut = 32'b0000_0000_0000_0000_0000_0000_0000_0010;
            5'd2:  decOut = 32'b0000_0000_0000_0000_0000_0000_0000_0100;
            5'd3:  decOut = 32'b0000_0000_0000_0000_0000_0000_0000_1000;
            5'd4:  decOut = 32'b0000_0000_0000_0000_0000_0000_0001_0000;
            5'd5:  decOut = 32'b0000_0000_0000_0000_0000_0000_0010_0000;
            5'd6:  decOut = 32'b0000_0000_0000_0000_0000_0000_0100_0000;
            5'd7:  decOut = 32'b0000_0000_0000_0000_0000_0000_1000_0000;
            5'd8:  decOut = 32'b0000_0000_0000_0000_0000_0001_0000_0000;
            5'd9:  decOut = 32'b0000_0000_0000_0000_0000_0010_0000_0000;
            5'd10: decOut = 32'b0000_0000_0000_0000_0000_0100_0000_0000;
            5'd11: decOut = 32'b0000_0000_0000_0000_0000_1000_0000_0000;
            5'd12: decOut = 32'b0000_0000_0000_0000_0001_0000_0000_0000;
            5'd13: decOut = 32'b0000_0000_0000_0000_0010_0000_0000_0000;
            5'd14: decOut = 32'b0000_0000_0000_0000_0100_0000_0000_0000;
            5'd15: decOut = 32'b0000_0000_0000_0000_1000_0000_0000_0000;
            5'd16: decOut = 32'b0000_0000_0000_0001_0000_0000_0000_0000;
            5'd17: decOut = 32'b0000_0000_0000_0010_0000_0000_0000_0000;
            5'd18: decOut = 32'b0000_0000_0000_0100_0000_0000_0000_0000;
            5'd19: decOut = 32'b0000_0000_0000_1000_0000_0000_0000_0000;
            5'd20: decOut = 32'b0000_0000_0001_0000_0000_0000_0000_0000;
            5'd21: decOut = 32'b0000_0000_0010_0000_0000_0000_0000_0000;
            5'd22: decOut = 32'b0000_0000_0100_0000_0000_0000_0000_0000;
            5'd23: decOut = 32'b0000_0000_1000_0000_0000_0000_0000_0000;
            5'd24: decOut = 32'b0000_0001_0000_0000_0000_0000_0000_0000;
            5'd25: decOut = 32'b0000_0010_0000_0000_0000_0000_0000_0000;
            5'd26: decOut = 32'b0000_0100_0000_0000_0000_0000_0000_0000;
            5'd27: decOut = 32'b0000_1000_0000_0000_0000_0000_0000_0000;
            5'd28: decOut = 32'b0001_0000_0000_0000_0000_0000_0000_0000;
            5'd29: decOut = 32'b0010_0000_0000_0000_0000_0000_0000_0000;
            5'd30: decOut = 32'b0100_0000_0000_0000_0000_0000_0000_0000;
            5'd31: decOut = 32'b1000_0000_0000_0000_0000_0000_0000_0000;
        endcase
    end
endmodule

module mux32to1_32bits(input [31:0] in0,  input [31:0] in1,  input [31:0] in2,  input [31:0] in3,
                       input [31:0] in4,  input [31:0] in5,  input [31:0] in6,  input [31:0] in7,
                       input [31:0] in8,  input [31:0] in9,  input [31:0] in10, input [31:0] in11,
                       input [31:0] in12, input [31:0] in13, input [31:0] in14, input [31:0] in15,
                       input [31:0] in16, input [31:0] in17, input [31:0] in18, input [31:0] in19,
                       input [31:0] in20, input [31:0] in21, input [31:0] in22, input [31:0] in23,
                       input [31:0] in24, input [31:0] in25, input [31:0] in26, input [31:0] in27,
                       input [31:0] in28, input [31:0] in29, input [31:0] in30, input [31:0] in31,
                       input [4:0] select, output reg [31:0] muxOut);
    always@(in0,  in1,  in2,  in3,  in4,  in5,  in6,  in7,
            in8,  in9,  in10, in11, in12, in13, in14, in15,
            in16, in17, in18, in19, in20, in21, in22, in23,
            in24, in25, in26, in27, in28, in29, in30, in31, select)
    begin
        case(select)
            5'd0:  muxOut = in0;
            5'd1:  muxOut = in1;
            5'd2:  muxOut = in2;
            5'd3:  muxOut = in3;
            5'd4:  muxOut = in4;
            5'd5:  muxOut = in5;
            5'd6:  muxOut = in6;
            5'd7:  muxOut = in7;
            5'd8:  muxOut = in8;
            5'd9:  muxOut = in9;
            5'd10: muxOut = in10;
            5'd11: muxOut = in11;
            5'd12: muxOut = in12;
            5'd13: muxOut = in13;
            5'd14: muxOut = in14;
            5'd15: muxOut = in15;
            5'd16: muxOut = in16;
            5'd17: muxOut = in17;
            5'd18: muxOut = in18;
            5'd19: muxOut = in19;
            5'd20: muxOut = in20;
            5'd21: muxOut = in21;
            5'd22: muxOut = in22;
            5'd23: muxOut = in23;
            5'd24: muxOut = in24;
            5'd25: muxOut = in25;
            5'd26: muxOut = in26;
            5'd27: muxOut = in27;
            5'd28: muxOut = in28;
            5'd29: muxOut = in29;
            5'd30: muxOut = in30;
            5'd31: muxOut = in31;
        endcase
    end
endmodule

module registerFile(input clk, input reset, input regWrite, input [4:0] rs, input [4:0] rt, input [4:0] rd,
                          input [31:0] writeData, output [31:0] regRs, output [31:0] regRt);
    wire [31:0] decOut;
    wire [31:0] outR0,  outR1,  outR2,  outR3,  outR4,  outR5,  outR6,  outR7;
    wire [31:0] outR8,  outR9,  outR10, outR11, outR12, outR13, outR14, outR15;
    wire [31:0] outR16, outR17, outR18, outR19, outR20, outR21, outR22, outR23;
    wire [31:0] outR24, outR25, outR26, outR27, outR28, outR29, outR30, outR31;

    decoder5to32 rdDec (rd, decOut);

    registerSet regSet (clk, reset, regWrite, decOut, writeData,
                        outR0,  outR1,  outR2,  outR3,
                        outR4,  outR5,  outR6,  outR7,
                        outR8,  outR9,  outR10, outR11,
                        outR12, outR13, outR14, outR15,
                        outR16, outR17, outR18, outR19,
                        outR20, outR21, outR22, outR23,
                        outR24, outR25, outR26, outR27,
                        outR28, outR29, outR30, outR31);

    mux32to1_32bits rsSel (outR0,  outR1,  outR2,  outR3,
                           outR4,  outR5,  outR6,  outR7,
                           outR8,  outR9,  outR10, outR11,
                           outR12, outR13, outR14, outR15,
                           outR16, outR17, outR18, outR19,
                           outR20, outR21, outR22, outR23,
                           outR24, outR25, outR26, outR27,
                           outR28, outR29, outR30, outR31,
                           rs, regRs);


    mux32to1_32bits rtSel (outR0,  outR1,  outR2,  outR3,
                           outR4,  outR5,  outR6,  outR7,
                           outR8,  outR9,  outR10, outR11,
                           outR12, outR13, outR14, outR15,
                           outR16, outR17, outR18, outR19,
                           outR20, outR21, outR22, outR23,
                           outR24, outR25, outR26, outR27,
                           outR28, outR29, outR30, outR31,
                           rt, regRt);

endmodule

