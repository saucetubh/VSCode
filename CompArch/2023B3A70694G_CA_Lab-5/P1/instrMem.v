/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
// Instruction Memory Starts
module Dff_IM(input clk, input reset, input d, output reg q);
    //WRITE YOUR CODE HERE
    always @(posedge clk, reset) begin
        if(reset) q <= 0;
        else q <= d;
    end
endmodule


/*              Link for generate block
                https://vlsiverify.com/verilog/generate-blocks-in-verilog
*/

module register_IM(input clk, input reset, input [7:0] inR, output [7:0] outR);
    //WRITE YOUR CODE HERE
    genvar k;
    generate
        for(k = 0; k < 8; k = k + 1) begin : dffs
            Dff_IM dff(.clk(clk), .reset(reset), .d(inR[k]), .q(outR[k]));      
        end
    endgenerate
endmodule

module mux128to1_IM(input [7:0] in0,   input [7:0] in1,   input [7:0] in2,   input [7:0] in3,
                    input [7:0] in4,   input [7:0] in5,   input [7:0] in6,   input [7:0] in7,
                    input [7:0] in8,   input [7:0] in9,   input [7:0] in10,  input [7:0] in11,
                    input [7:0] in12,  input [7:0] in13,  input [7:0] in14,  input [7:0] in15,
                    input [7:0] in16,  input [7:0] in17,  input [7:0] in18,  input [7:0] in19,
                    input [7:0] in20,  input [7:0] in21,  input [7:0] in22,  input [7:0] in23,
                    input [7:0] in24,  input [7:0] in25,  input [7:0] in26,  input [7:0] in27,
                    input [7:0] in28,  input [7:0] in29,  input [7:0] in30,  input [7:0] in31,
                    input [7:0] in32,  input [7:0] in33,  input [7:0] in34,  input [7:0] in35,
                    input [7:0] in36,  input [7:0] in37,  input [7:0] in38,  input [7:0] in39,
                    input [7:0] in40,  input [7:0] in41,  input [7:0] in42,  input [7:0] in43,
                    input [7:0] in44,  input [7:0] in45,  input [7:0] in46,  input [7:0] in47,
                    input [7:0] in48,  input [7:0] in49,  input [7:0] in50,  input [7:0] in51,
                    input [7:0] in52,  input [7:0] in53,  input [7:0] in54,  input [7:0] in55,
                    input [7:0] in56,  input [7:0] in57,  input [7:0] in58,  input [7:0] in59,
                    input [7:0] in60,  input [7:0] in61,  input [7:0] in62,  input [7:0] in63,
                    input [7:0] in64,  input [7:0] in65,  input [7:0] in66,  input [7:0] in67,
                    input [7:0] in68,  input [7:0] in69,  input [7:0] in70,  input [7:0] in71,
                    input [7:0] in72,  input [7:0] in73,  input [7:0] in74,  input [7:0] in75,
                    input [7:0] in76,  input [7:0] in77,  input [7:0] in78,  input [7:0] in79,
                    input [7:0] in80,  input [7:0] in81,  input [7:0] in82,  input [7:0] in83,
                    input [7:0] in84,  input [7:0] in85,  input [7:0] in86,  input [7:0] in87,
                    input [7:0] in88,  input [7:0] in89,  input [7:0] in90,  input [7:0] in91,
                    input [7:0] in92,  input [7:0] in93,  input [7:0] in94,  input [7:0] in95,
                    input [7:0] in96,  input [7:0] in97,  input [7:0] in98,  input [7:0] in99,
                    input [7:0] in100, input [7:0] in101, input [7:0] in102, input [7:0] in103,
                    input [7:0] in104, input [7:0] in105, input [7:0] in106, input [7:0] in107,
                    input [7:0] in108, input [7:0] in109, input [7:0] in110, input [7:0] in111,
                    input [7:0] in112, input [7:0] in113, input [7:0] in114, input [7:0] in115,
                    input [7:0] in116, input [7:0] in117, input [7:0] in118, input [7:0] in119,
                    input [7:0] in120, input [7:0] in121, input [7:0] in122, input [7:0] in123,
                    input [7:0] in124, input [7:0] in125, input [7:0] in126, input [7:0] in127,
                    input [4:0] select, output reg [31:0] muxOut);
    always@(in0,   in1,   in2,   in3,   in4,   in5,   in6,   in7, 
            in8,   in9,   in10,  in11,  in12,  in13,  in14,  in15,   
            in16,  in17,  in18,  in19,  in20,  in21,  in22,  in23, 
            in24,  in25,  in26,  in27,  in28,  in29,  in30,  in31, 
            in32,  in33,  in34,  in35,  in36,  in37,  in38,  in39, 
            in40,  in41,  in42,  in43,  in44,  in45,  in46,  in47, 
            in48,  in49,  in50,  in51,  in52,  in53,  in54,  in55, 
            in56,  in57,  in58,  in59,  in60,  in61,  in62,  in63, 
            in64,  in65,  in66,  in67,  in68,  in69,  in70,  in71, 
            in72,  in73,  in74,  in75,  in76,  in77,  in78,  in79, 
            in80,  in81,  in82,  in83,  in84,  in85,  in86,  in87, 
            in88,  in89,  in90,  in91,  in92,  in93,  in94,  in95, 
            in96,  in97,  in98,  in99,  in100, in101, in102, in103,
            in104, in105, in106, in107, in108, in109, in110, in111,
            in112, in113, in114, in115, in116, in117, in118, in119,
            in120, in121, in122, in123, in124, in125, in126, in127,
            select)
	begin
        case(select)
            5'd0:  muxOut = {in0,   in1,   in2,   in3  };
            5'd1:  muxOut = {in4,   in5,   in6,   in7  };
            5'd2:  muxOut = {in8,   in9,   in10,  in11 };
            5'd3:  muxOut = {in12,  in13,  in14,  in15 };
            5'd4:  muxOut = {in16,  in17,  in18,  in19 };
            5'd5:  muxOut = {in20,  in21,  in22,  in23 };
            5'd6:  muxOut = {in24,  in25,  in26,  in27 };
            5'd7:  muxOut = {in28,  in29,  in30,  in31 };
            5'd8:  muxOut = {in32,  in33,  in34,  in35 };
            5'd9:  muxOut = {in36,  in37,  in38,  in39 };
            5'd10: muxOut = {in40,  in41,  in42,  in43 };
            5'd11: muxOut = {in44,  in45,  in46,  in47 };
            5'd12: muxOut = {in48,  in49,  in50,  in51 };
            5'd13: muxOut = {in52,  in53,  in54,  in55 };
            5'd14: muxOut = {in56,  in57,  in58,  in59 };
            5'd15: muxOut = {in60,  in61,  in62,  in63 };
            5'd16: muxOut = {in64,  in65,  in66,  in67 };
            5'd17: muxOut = {in68,  in69,  in70,  in71 };
            5'd18: muxOut = {in72,  in73,  in74,  in75 };
            5'd19: muxOut = {in76,  in77,  in78,  in79 };
            5'd20: muxOut = {in80,  in81,  in82,  in83 };
            5'd21: muxOut = {in84,  in85,  in86,  in87 };
            5'd22: muxOut = {in88,  in89,  in90,  in91 };
            5'd23: muxOut = {in92,  in93,  in94,  in95 };
            5'd24: muxOut = {in96,  in97,  in98,  in99 };
            5'd25: muxOut = {in100, in101, in102, in103};
            5'd26: muxOut = {in104, in105, in106, in107};
            5'd27: muxOut = {in108, in109, in110, in111};
            5'd28: muxOut = {in112, in113, in114, in115};
            5'd29: muxOut = {in116, in117, in118, in119};
            5'd30: muxOut = {in120, in121, in122, in123};
            5'd31: muxOut = {in124, in125, in126, in127};
        endcase
    end
endmodule

module IM(input clk, input reset, input [4:0] pc_5bits, output [31:0] IR);
    wire [7:0] outR0,   outR1,   outR2,   outR3,   outR4,   outR5,   outR6,   outR7,   
               outR8,   outR9,   outR10,  outR11,  outR12,  outR13,  outR14,  outR15,   
               outR16,  outR17,  outR18,  outR19,  outR20,  outR21,  outR22,  outR23, 
               outR24,  outR25,  outR26,  outR27,  outR28,  outR29,  outR30,  outR31, 
               outR32,  outR33,  outR34,  outR35,  outR36,  outR37,  outR38,  outR39, 
               outR40,  outR41,  outR42,  outR43,  outR44,  outR45,  outR46,  outR47, 
               outR48,  outR49,  outR50,  outR51,  outR52,  outR53,  outR54,  outR55, 
               outR56,  outR57,  outR58,  outR59,  outR60,  outR61,  outR62,  outR63, 
               outR64,  outR65,  outR66,  outR67,  outR68,  outR69,  outR70,  outR71, 
               outR72,  outR73,  outR74,  outR75,  outR76,  outR77,  outR78,  outR79, 
               outR80,  outR81,  outR82,  outR83,  outR84,  outR85,  outR86,  outR87, 
               outR88,  outR89,  outR90,  outR91,  outR92,  outR93,  outR94,  outR95, 
               outR96,  outR97,  outR98,  outR99,  outR100, outR101, outR102, outR103,
               outR104, outR105, outR106, outR107, outR108, outR109, outR110, outR111,
               outR112, outR113, outR114, outR115, outR116, outR117, outR118, outR119,
               outR120, outR121, outR122, outR123, outR124, outR125, outR126, outR127;
    register_IM rIM0   (clk, reset, 8'b00100000, outR0); //ADDI R1, R0, 124 - ---- R1 <- R0 + 124
    register_IM rIM1   (clk, reset, 8'b00000001, outR1);   
    register_IM rIM2   (clk, reset, 8'b00000000, outR2);   
    register_IM rIM3   (clk, reset, 8'b01111100, outR3); 

    register_IM rIM4   (clk, reset, 8'b00100000, outR4);  //ADDI R2, R0, 2 - ---- R2 <- R0 + 2 // counter
    register_IM rIM5   (clk, reset, 8'b00000010, outR5);  
    register_IM rIM6   (clk, reset, 8'b00000000, outR6);  
    register_IM rIM7   (clk, reset, 8'b00000010, outR7);   

    register_IM rIM8   (clk, reset, 8'b00100000, outR8);  //ADDI R7, R0, 7 - ---- R7 <- R0 + 7 // Max val
    register_IM rIM9   (clk, reset, 8'b00000111, outR9);   
    register_IM rIM10  (clk, reset, 8'b00000000, outR10);   
    register_IM rIM11  (clk, reset, 8'b00000111, outR11);

    register_IM rIM12  (clk, reset, 8'b10001100, outR12);  //LW R3, R1, 0 - ---- R3 <- Dmem[R1 + 0]
    register_IM rIM13  (clk, reset, 8'b00100011, outR13);  
    register_IM rIM14  (clk, reset, 8'b00000000, outR14);  
    register_IM rIM15  (clk, reset, 8'b00000000, outR15); 
    register_IM rIM16  (clk, reset, 8'b00100000, outR16); // ADDI R1, R1, -4 - ---- R1 <- R1 - 4   //R1 =120
    register_IM rIM17  (clk, reset, 8'b00100001, outR17);  
    register_IM rIM18  (clk, reset, 8'b11111111, outR18);  
    register_IM rIM19  (clk, reset, 8'b11111100, outR19); 
    register_IM rIM20  (clk, reset, 8'b10001100, outR20); //LW R4, R1, 0 - ---- R4 <- Dmem[R1 + 0]
    register_IM rIM21  (clk, reset, 8'b00100100, outR21);  
    register_IM rIM22  (clk, reset, 8'b00000000, outR22);  
    register_IM rIM23  (clk, reset, 8'b00000000, outR23); 
    register_IM rIM24  (clk, reset, 8'b00000000, outR24); //ADD R5, R3, R4 - ---- R5 <- R3 + R4
    register_IM rIM25  (clk, reset, 8'b01100100, outR25);  
    register_IM rIM26  (clk, reset, 8'b00101000, outR26);  
    register_IM rIM27  (clk, reset, 8'b00100000, outR27); 

    register_IM rIM28  (clk, reset, 8'b10101100, outR28); //SW R5, R1, -4 - ---- Dmem[R1 - 4] <- R5 // 120-4 = 116
    register_IM rIM29  (clk, reset, 8'b00100101, outR29);   
    register_IM rIM30  (clk, reset, 8'b11111111, outR30);   
    register_IM rIM31  (clk, reset, 8'b11111100, outR31);  
    register_IM rIM32  (clk, reset, 8'b00100000, outR32); //ADDI R2, R2, 1 - ---- R2 <- R2 + 1   //Counter
    register_IM rIM33  (clk, reset, 8'b01000010, outR33);   
    register_IM rIM34  (clk, reset, 8'b00000000, outR34);   
    register_IM rIM35  (clk, reset, 8'b00000001, outR35);  
    register_IM rIM36  (clk, reset, 8'b00010100, outR36); //BNE R7, R2, -7(instructions)
    register_IM rIM37  (clk, reset, 8'b01000111, outR37);   
    register_IM rIM38  (clk, reset, 8'b11111111, outR38);   
    register_IM rIM39  (clk, reset, 8'b11111001, outR39);  
    register_IM rIM40  (clk, reset, 8'h00, outR40); 
    register_IM rIM41  (clk, reset, 8'h00, outR41);  
    register_IM rIM42  (clk, reset, 8'h00, outR42);  
    register_IM rIM43  (clk, reset, 8'h00, outR43); 
    register_IM rIM44  (clk, reset, 8'h00, outR44);                      
    register_IM rIM45  (clk, reset, 8'h00, outR45);             
    register_IM rIM46  (clk, reset, 8'h00, outR46);             
    register_IM rIM47  (clk, reset, 8'h00, outR47); 
    register_IM rIM48  (clk, reset, 8'h00, outR48); 
    register_IM rIM49  (clk, reset, 8'h00, outR49);  
    register_IM rIM50  (clk, reset, 8'h00, outR50);  
    register_IM rIM51  (clk, reset, 8'h00, outR51); 
    register_IM rIM52  (clk, reset, 8'h00, outR52);   
    register_IM rIM53  (clk, reset, 8'h00, outR53);  
    register_IM rIM54  (clk, reset, 8'h00, outR54);  
    register_IM rIM55  (clk, reset, 8'h00, outR55);  
    register_IM rIM56  (clk, reset, 8'h00, outR56);                     
    register_IM rIM57  (clk, reset, 8'h00, outR57);             
    register_IM rIM58  (clk, reset, 8'h00, outR58);             
    register_IM rIM59  (clk, reset, 8'h00, outR59);  
    register_IM rIM60  (clk, reset, 8'h00, outR60); 
    register_IM rIM61  (clk, reset, 8'h00, outR61); 
    register_IM rIM62  (clk, reset, 8'h00, outR62); 
    register_IM rIM63  (clk, reset, 8'h00, outR63); 
    register_IM rIM64  (clk, reset, 8'h00, outR64);
    register_IM rIM65  (clk, reset, 8'h00, outR65);
    register_IM rIM66  (clk, reset, 8'h00, outR66);
    register_IM rIM67  (clk, reset, 8'h00, outR67);
    register_IM rIM68  (clk, reset, 8'h00, outR68);
    register_IM rIM69  (clk, reset, 8'h00, outR69);
    register_IM rIM70  (clk, reset, 8'h00, outR70);
    register_IM rIM71  (clk, reset, 8'h00, outR71);
    register_IM rIM72  (clk, reset, 8'h00, outR72);
    register_IM rIM73  (clk, reset, 8'h00, outR73);
    register_IM rIM74  (clk, reset, 8'h00, outR74);
    register_IM rIM75  (clk, reset, 8'h00, outR75);
    register_IM rIM76  (clk, reset, 8'h00, outR76);
    register_IM rIM77  (clk, reset, 8'h00, outR77);
    register_IM rIM78  (clk, reset, 8'h00, outR78);
    register_IM rIM79  (clk, reset, 8'h00, outR79);
    register_IM rIM80  (clk, reset, 8'h00, outR80);
    register_IM rIM81  (clk, reset, 8'h00, outR81);
    register_IM rIM82  (clk, reset, 8'h00, outR82);
    register_IM rIM83  (clk, reset, 8'h00, outR83);
    register_IM rIM84  (clk, reset, 8'h00, outR84);
    register_IM rIM85  (clk, reset, 8'h00, outR85);
    register_IM rIM86  (clk, reset, 8'h00, outR86);
    register_IM rIM87  (clk, reset, 8'h00, outR87);
    register_IM rIM88  (clk, reset, 8'h00, outR88);
    register_IM rIM89  (clk, reset, 8'h00, outR89);
    register_IM rIM90  (clk, reset, 8'h00, outR90);
    register_IM rIM91  (clk, reset, 8'h00, outR91);
    register_IM rIM92  (clk, reset, 8'h00, outR92);
    register_IM rIM93  (clk, reset, 8'h00, outR93);
    register_IM rIM94  (clk, reset, 8'h00, outR94);
    register_IM rIM95  (clk, reset, 8'h00, outR95);
    register_IM rIM96  (clk, reset, 8'h00, outR96);
    register_IM rIM97  (clk, reset, 8'h00, outR97);
    register_IM rIM98  (clk, reset, 8'h00, outR98);
    register_IM rIM99  (clk, reset, 8'h00, outR99);
    register_IM rIM100 (clk, reset, 8'h00, outR100);
    register_IM rIM101 (clk, reset, 8'h00, outR101);
    register_IM rIM102 (clk, reset, 8'h00, outR102);
    register_IM rIM103 (clk, reset, 8'h00, outR103);
    register_IM rIM104 (clk, reset, 8'h00, outR104);
    register_IM rIM105 (clk, reset, 8'h00, outR105);
    register_IM rIM106 (clk, reset, 8'h00, outR106);
    register_IM rIM107 (clk, reset, 8'h00, outR107);
    register_IM rIM108 (clk, reset, 8'h00, outR108);
    register_IM rIM109 (clk, reset, 8'h00, outR109);
    register_IM rIM110 (clk, reset, 8'h00, outR110);
    register_IM rIM111 (clk, reset, 8'h00, outR111);
    register_IM rIM112 (clk, reset, 8'h00, outR112);
    register_IM rIM113 (clk, reset, 8'h00, outR113);
    register_IM rIM114 (clk, reset, 8'h00, outR114);
    register_IM rIM115 (clk, reset, 8'h00, outR115);
    register_IM rIM116 (clk, reset, 8'h00, outR116);
    register_IM rIM117 (clk, reset, 8'h00, outR117);
    register_IM rIM118 (clk, reset, 8'h00, outR118);
    register_IM rIM119 (clk, reset, 8'h00, outR119);
    register_IM rIM120 (clk, reset, 8'h00, outR120);
    register_IM rIM121 (clk, reset, 8'h00, outR121);
    register_IM rIM122 (clk, reset, 8'h00, outR122);
    register_IM rIM123 (clk, reset, 8'h00, outR123);
    register_IM rIM124 (clk, reset, 8'h00, outR124);
    register_IM rIM125 (clk, reset, 8'h00, outR125);
    register_IM rIM126 (clk, reset, 8'h00, outR126);
    register_IM rIM127 (clk, reset, 8'h00, outR127);

    mux128to1_IM muxIM (outR0,   outR1,   outR2,   outR3,   outR4,   outR5,   outR6,   outR7,   
                        outR8,   outR9,   outR10,  outR11,  outR12,  outR13,  outR14,  outR15,   
                        outR16,  outR17,  outR18,  outR19,  outR20,  outR21,  outR22,  outR23, 
                        outR24,  outR25,  outR26,  outR27,  outR28,  outR29,  outR30,  outR31, 
                        outR32,  outR33,  outR34,  outR35,  outR36,  outR37,  outR38,  outR39, 
                        outR40,  outR41,  outR42,  outR43,  outR44,  outR45,  outR46,  outR47, 
                        outR48,  outR49,  outR50,  outR51,  outR52,  outR53,  outR54,  outR55, 
                        outR56,  outR57,  outR58,  outR59,  outR60,  outR61,  outR62,  outR63, 
                        outR64,  outR65,  outR66,  outR67,  outR68,  outR69,  outR70,  outR71, 
                        outR72,  outR73,  outR74,  outR75,  outR76,  outR77,  outR78,  outR79, 
                        outR80,  outR81,  outR82,  outR83,  outR84,  outR85,  outR86,  outR87, 
                        outR88,  outR89,  outR90,  outR91,  outR92,  outR93,  outR94,  outR95, 
                        outR96,  outR97,  outR98,  outR99,  outR100, outR101, outR102, outR103,
                        outR104, outR105, outR106, outR107, outR108, outR109, outR110, outR111,
                        outR112, outR113, outR114, outR115, outR116, outR117, outR118, outR119,
                        outR120, outR121, outR122, outR123, outR124, outR125, outR126, outR127,
                        pc_5bits, IR);
endmodule