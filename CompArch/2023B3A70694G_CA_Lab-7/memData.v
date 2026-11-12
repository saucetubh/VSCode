/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/

module Dff_DM(input clk, input reset, input regWrite, input decOut1b , input d, output reg q);
    always @ (negedge clk)
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

//Data Memory Starts 
module register8bit(input clk, input reset, input regWrite, input decOut1b, input [7:0] inR, 
                     output [7:0] outR);
    Dff_DM d0  (clk, reset, regWrite, decOut1b, inR[0],  outR[0]);
    Dff_DM d1  (clk, reset, regWrite, decOut1b, inR[1],  outR[1]);
    Dff_DM d2  (clk, reset, regWrite, decOut1b, inR[2],  outR[2]);
    Dff_DM d3  (clk, reset, regWrite, decOut1b, inR[3],  outR[3]);
    Dff_DM d4  (clk, reset, regWrite, decOut1b, inR[4],  outR[4]);
    Dff_DM d5  (clk, reset, regWrite, decOut1b, inR[5],  outR[5]);
    Dff_DM d6  (clk, reset, regWrite, decOut1b, inR[6],  outR[6]);
    Dff_DM d7  (clk, reset, regWrite, decOut1b, inR[7],  outR[7]);
endmodule

module DM(input clk, input reset, input memRead, input memWrite, input [4:0] address, input [31:0] writeData,  output [31:0] memOut);
    wire [7:0] mem0,   mem1,   mem2,   mem3,   mem4,   mem5,   mem6,   mem7,   
               mem8,   mem9,   mem10,  mem11,  mem12,  mem13,  mem14,  mem15,   
               mem16,  mem17,  mem18,  mem19,  mem20,  mem21,  mem22,  mem23, 
               mem24,  mem25,  mem26,  mem27,  mem28,  mem29,  mem30,  mem31, 
               mem32,  mem33,  mem34,  mem35,  mem36,  mem37,  mem38,  mem39, 
               mem40,  mem41,  mem42,  mem43,  mem44,  mem45,  mem46,  mem47, 
               mem48,  mem49,  mem50,  mem51,  mem52,  mem53,  mem54,  mem55, 
               mem56,  mem57,  mem58,  mem59,  mem60,  mem61,  mem62,  mem63, 
               mem64,  mem65,  mem66,  mem67,  mem68,  mem69,  mem70,  mem71, 
               mem72,  mem73,  mem74,  mem75,  mem76,  mem77,  mem78,  mem79, 
               mem80,  mem81,  mem82,  mem83,  mem84,  mem85,  mem86,  mem87, 
               mem88,  mem89,  mem90,  mem91,  mem92,  mem93,  mem94,  mem95, 
               mem96,  mem97,  mem98,  mem99,  mem100, mem101, mem102, mem103,
               mem104, mem105, mem106, mem107, mem108, mem109, mem110, mem111,
               mem112, mem113, mem114, mem115, mem116, mem117, mem118, mem119,
               mem120, mem121, mem122, mem123, mem124, mem125, mem126, mem127;

    wire [31:0] decOut;
    wire [31:0] memReadOut;
    decoder5to32 writeDec (address, decOut);

    // 4 registers one decout
    register8bit rMem0   (clk, reset, memWrite, decOut[0],  writeData[31:24], mem0);
    register8bit rMem1   (clk, reset, memWrite, decOut[0],  writeData[23:16], mem1);   
    register8bit rMem2   (clk, reset, memWrite, decOut[0],  writeData[15: 8], mem2);   
    register8bit rMem3   (clk, reset, memWrite, decOut[0],  writeData[7 : 0], mem3);   
    register8bit rMem4   (clk, reset, memWrite, decOut[1],  writeData[31:24], mem4);
    register8bit rMem5   (clk, reset, memWrite, decOut[1],  writeData[23:16], mem5);  
    register8bit rMem6   (clk, reset, memWrite, decOut[1],  writeData[15: 8], mem6);  
    register8bit rMem7   (clk, reset, memWrite, decOut[1],  writeData[7 : 0], mem7);   
    register8bit rMem8   (clk, reset, memWrite, decOut[2],  writeData[31:24], mem8); 
    register8bit rMem9   (clk, reset, memWrite, decOut[2],  writeData[23:16], mem9);   
    register8bit rMem10  (clk, reset, memWrite, decOut[2],  writeData[15: 8], mem10);   
    register8bit rMem11  (clk, reset, memWrite, decOut[2],  writeData[7 : 0], mem11);   
    register8bit rMem12  (clk, reset, memWrite, decOut[3],  writeData[31:24], mem12); 
    register8bit rMem13  (clk, reset, memWrite, decOut[3],  writeData[23:16], mem13);  
    register8bit rMem14  (clk, reset, memWrite, decOut[3],  writeData[15: 8], mem14);  
    register8bit rMem15  (clk, reset, memWrite, decOut[3],  writeData[7 : 0], mem15); 
    register8bit rMem16  (clk, reset, memWrite, decOut[4],  writeData[31:24], mem16); 
    register8bit rMem17  (clk, reset, memWrite, decOut[4],  writeData[23:16], mem17);  
    register8bit rMem18  (clk, reset, memWrite, decOut[4],  writeData[15: 8], mem18);  
    register8bit rMem19  (clk, reset, memWrite, decOut[4],  writeData[7 : 0], mem19); 
    register8bit rMem20  (clk, reset, memWrite, decOut[5],  writeData[31:24], mem20);  
    register8bit rMem21  (clk, reset, memWrite, decOut[5],  writeData[23:16], mem21);  
    register8bit rMem22  (clk, reset, memWrite, decOut[5],  writeData[15: 8], mem22);  
    register8bit rMem23  (clk, reset, memWrite, decOut[5],  writeData[7 : 0], mem23); 
    register8bit rMem24  (clk, reset, memWrite, decOut[6],  writeData[31:24], mem24); 
    register8bit rMem25  (clk, reset, memWrite, decOut[6],  writeData[23:16], mem25);  
    register8bit rMem26  (clk, reset, memWrite, decOut[6],  writeData[15: 8], mem26);  
    register8bit rMem27  (clk, reset, memWrite, decOut[6],  writeData[7 : 0], mem27);
    register8bit rMem28  (clk, reset, memWrite, decOut[7],  writeData[31:24], mem28);  
    register8bit rMem29  (clk, reset, memWrite, decOut[7],  writeData[23:16], mem29);   
    register8bit rMem30  (clk, reset, memWrite, decOut[7],  writeData[15: 8], mem30);   
    register8bit rMem31  (clk, reset, memWrite, decOut[7],  writeData[7 : 0], mem31);  
    register8bit rMem32  (clk, reset, memWrite, decOut[8],  writeData[31:24], mem32);  
    register8bit rMem33  (clk, reset, memWrite, decOut[8],  writeData[23:16], mem33);   
    register8bit rMem34  (clk, reset, memWrite, decOut[8],  writeData[15: 8], mem34);   
    register8bit rMem35  (clk, reset, memWrite, decOut[8],  writeData[7 : 0], mem35);
    register8bit rMem36  (clk, reset, memWrite, decOut[9],  writeData[31:24], mem36);  
    register8bit rMem37  (clk, reset, memWrite, decOut[9],  writeData[23:16], mem37);   
    register8bit rMem38  (clk, reset, memWrite, decOut[9],  writeData[15: 8], mem38);   
    register8bit rMem39  (clk, reset, memWrite, decOut[9],  writeData[7 : 0], mem39);  
    register8bit rMem40  (clk, reset, memWrite, decOut[10], writeData[31:24], mem40);  
    register8bit rMem41  (clk, reset, memWrite, decOut[10], writeData[23:16], mem41);  
    register8bit rMem42  (clk, reset, memWrite, decOut[10], writeData[15: 8], mem42);  
    register8bit rMem43  (clk, reset, memWrite, decOut[10], writeData[7 : 0], mem43); 
    register8bit rMem44  (clk, reset, memWrite, decOut[11], writeData[31:24], mem44);                       
    register8bit rMem45  (clk, reset, memWrite, decOut[11], writeData[23:16], mem45);             
    register8bit rMem46  (clk, reset, memWrite, decOut[11], writeData[15: 8], mem46);             
    register8bit rMem47  (clk, reset, memWrite, decOut[11], writeData[7 : 0], mem47); 
    register8bit rMem48  (clk, reset, memWrite, decOut[12], writeData[31:24], mem48);  
    register8bit rMem49  (clk, reset, memWrite, decOut[12], writeData[23:16], mem49);  
    register8bit rMem50  (clk, reset, memWrite, decOut[12], writeData[15: 8], mem50);  
    register8bit rMem51  (clk, reset, memWrite, decOut[12], writeData[7 : 0], mem51); 
    register8bit rMem52  (clk, reset, memWrite, decOut[13], writeData[31:24], mem52);  
    register8bit rMem53  (clk, reset, memWrite, decOut[13], writeData[23:16], mem53);  
    register8bit rMem54  (clk, reset, memWrite, decOut[13], writeData[15: 8], mem54);  
    register8bit rMem55  (clk, reset, memWrite, decOut[13], writeData[7 : 0], mem55);  
    register8bit rMem56  (clk, reset, memWrite, decOut[14], writeData[31:24], mem56);                       
    register8bit rMem57  (clk, reset, memWrite, decOut[14], writeData[23:16], mem57);             
    register8bit rMem58  (clk, reset, memWrite, decOut[14], writeData[15: 8], mem58);             
    register8bit rMem59  (clk, reset, memWrite, decOut[14], writeData[7 : 0], mem59);  
    register8bit rMem60  (clk, reset, memWrite, decOut[15], writeData[31:24], mem60);
    register8bit rMem61  (clk, reset, memWrite, decOut[15], writeData[23:16], mem61); 
    register8bit rMem62  (clk, reset, memWrite, decOut[15], writeData[15: 8], mem62); 
    register8bit rMem63  (clk, reset, memWrite, decOut[15], writeData[7 : 0], mem63); 
    register8bit rMem64  (clk, reset, memWrite, decOut[16], writeData[31:24], mem64);
    register8bit rMem65  (clk, reset, memWrite, decOut[16], writeData[23:16], mem65); 
    register8bit rMem66  (clk, reset, memWrite, decOut[16], writeData[15: 8], mem66);
    register8bit rMem67  (clk, reset, memWrite, decOut[16], writeData[7 : 0], mem67);
    register8bit rMem68  (clk, reset, memWrite, decOut[17], writeData[31:24], mem68);
    register8bit rMem69  (clk, reset, memWrite, decOut[17], writeData[23:16], mem69);
    register8bit rMem70  (clk, reset, memWrite, decOut[17], writeData[15: 8], mem70);
    register8bit rMem71  (clk, reset, memWrite, decOut[17], writeData[7 : 0], mem71);
    register8bit rMem72  (clk, reset, memWrite, decOut[18], writeData[31:24], mem72);
    register8bit rMem73  (clk, reset, memWrite, decOut[18], writeData[23:16], mem73);
    register8bit rMem74  (clk, reset, memWrite, decOut[18], writeData[15: 8], mem74);
    register8bit rMem75  (clk, reset, memWrite, decOut[18], writeData[7 : 0], mem75);
    register8bit rMem76  (clk, reset, memWrite, decOut[19], writeData[31:24], mem76);
    register8bit rMem77  (clk, reset, memWrite, decOut[19], writeData[23:16], mem77);
    register8bit rMem78  (clk, reset, memWrite, decOut[19], writeData[15: 8], mem78);
    register8bit rMem79  (clk, reset, memWrite, decOut[19], writeData[7 : 0], mem79);
    register8bit rMem80  (clk, reset, memWrite, decOut[20], writeData[31:24], mem80);
    register8bit rMem81  (clk, reset, memWrite, decOut[20], writeData[23:16], mem81);
    register8bit rMem82  (clk, reset, memWrite, decOut[20], writeData[15: 8], mem82);
    register8bit rMem83  (clk, reset, memWrite, decOut[20], writeData[7 : 0], mem83);
    register8bit rMem84  (clk, reset, memWrite, decOut[21], writeData[31:24], mem84);
    register8bit rMem85  (clk, reset, memWrite, decOut[21], writeData[23:16], mem85);
    register8bit rMem86  (clk, reset, memWrite, decOut[21], writeData[15: 8], mem86);
    register8bit rMem87  (clk, reset, memWrite, decOut[21], writeData[7 : 0], mem87);
    register8bit rMem88  (clk, reset, memWrite, decOut[22], writeData[31:24], mem88);
    register8bit rMem89  (clk, reset, memWrite, decOut[22], writeData[23:16], mem89);
    register8bit rMem90  (clk, reset, memWrite, decOut[22], writeData[15: 8], mem90);
    register8bit rMem91  (clk, reset, memWrite, decOut[22], writeData[7 : 0], mem91);
    register8bit rMem92  (clk, reset, memWrite, decOut[23], writeData[31:24], mem92);
    register8bit rMem93  (clk, reset, memWrite, decOut[23], writeData[23:16], mem93);
    register8bit rMem94  (clk, reset, memWrite, decOut[23], writeData[15: 8], mem94);
    register8bit rMem95  (clk, reset, memWrite, decOut[23], writeData[7 : 0], mem95);
    register8bit rMem96  (clk, reset, memWrite, decOut[24], writeData[31:24], mem96);
    register8bit rMem97  (clk, reset, memWrite, decOut[24], writeData[23:16], mem97);
    register8bit rMem98  (clk, reset, memWrite, decOut[24], writeData[15: 8], mem98);
    register8bit rMem99  (clk, reset, memWrite, decOut[24], writeData[7 : 0], mem99);
    register8bit rMem100 (clk, reset, memWrite, decOut[25], writeData[31:24], mem100);
    register8bit rMem101 (clk, reset, memWrite, decOut[25], writeData[23:16], mem101);
    register8bit rMem102 (clk, reset, memWrite, decOut[25], writeData[15: 8], mem102);
    register8bit rMem103 (clk, reset, memWrite, decOut[25], writeData[7 : 0], mem103);
    register8bit rMem104 (clk, reset, memWrite, decOut[26], writeData[31:24], mem104);
    register8bit rMem105 (clk, reset, memWrite, decOut[26], writeData[23:16], mem105);
    register8bit rMem106 (clk, reset, memWrite, decOut[26], writeData[15: 8], mem106);
    register8bit rMem107 (clk, reset, memWrite, decOut[26], writeData[7 : 0], mem107);
    register8bit rMem108 (clk, reset, memWrite, decOut[27], writeData[31:24], mem108);
    register8bit rMem109 (clk, reset, memWrite, decOut[27], writeData[23:16], mem109);
    register8bit rMem110 (clk, reset, memWrite, decOut[27], writeData[15: 8], mem110);
    register8bit rMem111 (clk, reset, memWrite, decOut[27], writeData[7 : 0], mem111);
    register8bit rMem112 (clk, reset, memWrite, decOut[28], writeData[31:24], mem112);
    register8bit rMem113 (clk, reset, memWrite, decOut[28], writeData[23:16], mem113);
    register8bit rMem114 (clk, reset, memWrite, decOut[28], writeData[15: 8], mem114);
    register8bit rMem115 (clk, reset, memWrite, decOut[28], writeData[7 : 0], mem115);
    register8bit rMem116 (clk, reset, memWrite, decOut[29], writeData[31:24], mem116);
    register8bit rMem117 (clk, reset, memWrite, decOut[29], writeData[23:16], mem117);
    register8bit rMem118 (clk, reset, memWrite, decOut[29], writeData[15: 8], mem118);
    register8bit rMem119 (clk, reset, memWrite, decOut[29], writeData[7 : 0], mem119);

    register8bit rMem120 (clk, reset, 1'b1, 1'b1, 8'b00000000, mem120); // Fib 2
    register8bit rMem121 (clk, reset, 1'b1, 1'b1, 8'b00000000, mem121);
    register8bit rMem122 (clk, reset, 1'b1, 1'b1, 8'b00000000, mem122);
    register8bit rMem123 (clk, reset, 1'b1, 1'b1, 8'b00000001, mem123);

    register8bit rMem124 (clk, reset, 1'b1, 1'b1, 8'b00000000, mem124); // Fib 3
    register8bit rMem125 (clk, reset, 1'b1, 1'b1, 8'b00000000, mem125);
    register8bit rMem126 (clk, reset, 1'b1, 1'b1, 8'b00000000, mem126);
    register8bit rMem127 (clk, reset, 1'b1, 1'b1, 8'b00000001, mem127);

    mux128to1_M muxMemRead  (mem0,   mem1,   mem2,   mem3,   mem4,   mem5,   mem6,   mem7,   
                             mem8,   mem9,   mem10,  mem11,  mem12,  mem13,  mem14,  mem15,   
                             mem16,  mem17,  mem18,  mem19,  mem20,  mem21,  mem22,  mem23, 
                             mem24,  mem25,  mem26,  mem27,  mem28,  mem29,  mem30,  mem31, 
                             mem32,  mem33,  mem34,  mem35,  mem36,  mem37,  mem38,  mem39, 
                             mem40,  mem41,  mem42,  mem43,  mem44,  mem45,  mem46,  mem47, 
                             mem48,  mem49,  mem50,  mem51,  mem52,  mem53,  mem54,  mem55, 
                             mem56,  mem57,  mem58,  mem59,  mem60,  mem61,  mem62,  mem63, 
                             mem64,  mem65,  mem66,  mem67,  mem68,  mem69,  mem70,  mem71, 
                             mem72,  mem73,  mem74,  mem75,  mem76,  mem77,  mem78,  mem79, 
                             mem80,  mem81,  mem82,  mem83,  mem84,  mem85,  mem86,  mem87, 
                             mem88,  mem89,  mem90,  mem91,  mem92,  mem93,  mem94,  mem95, 
                             mem96,  mem97,  mem98,  mem99,  mem100, mem101, mem102, mem103,
                             mem104, mem105, mem106, mem107, mem108, mem109, mem110, mem111,
                             mem112, mem113, mem114, mem115, mem116, mem117, mem118, mem119,
                             mem120, mem121, mem122, mem123, mem124, mem125, mem126, mem127,
                             address, memReadOut);
    mux2to1_32bits muxReadIM (32'b0, memReadOut, memRead, memOut); 							
endmodule

