/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

module Dff_DM(input clk, input reset, input regWrite, input decOut1b , input d, output reg q);
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
    wire [7:0] Dmem0,   Dmem1,   Dmem2,   Dmem3,   Dmem4,   Dmem5,   Dmem6,   Dmem7,   
               Dmem8,   Dmem9,   Dmem10,  Dmem11,  Dmem12,  Dmem13,  Dmem14,  Dmem15,   
               Dmem16,  Dmem17,  Dmem18,  Dmem19,  Dmem20,  Dmem21,  Dmem22,  Dmem23, 
               Dmem24,  Dmem25,  Dmem26,  Dmem27,  Dmem28,  Dmem29,  Dmem30,  Dmem31, 
               Dmem32,  Dmem33,  Dmem34,  Dmem35,  Dmem36,  Dmem37,  Dmem38,  Dmem39, 
               Dmem40,  Dmem41,  Dmem42,  Dmem43,  Dmem44,  Dmem45,  Dmem46,  Dmem47, 
               Dmem48,  Dmem49,  Dmem50,  Dmem51,  Dmem52,  Dmem53,  Dmem54,  Dmem55, 
               Dmem56,  Dmem57,  Dmem58,  Dmem59,  Dmem60,  Dmem61,  Dmem62,  Dmem63, 
               Dmem64,  Dmem65,  Dmem66,  Dmem67,  Dmem68,  Dmem69,  Dmem70,  Dmem71, 
               Dmem72,  Dmem73,  Dmem74,  Dmem75,  Dmem76,  Dmem77,  Dmem78,  Dmem79, 
               Dmem80,  Dmem81,  Dmem82,  Dmem83,  Dmem84,  Dmem85,  Dmem86,  Dmem87, 
               Dmem88,  Dmem89,  Dmem90,  Dmem91,  Dmem92,  Dmem93,  Dmem94,  Dmem95, 
               Dmem96,  Dmem97,  Dmem98,  Dmem99,  Dmem100, Dmem101, Dmem102, Dmem103,
               Dmem104, Dmem105, Dmem106, Dmem107, Dmem108, Dmem109, Dmem110, Dmem111,
               Dmem112, Dmem113, Dmem114, Dmem115, Dmem116, Dmem117, Dmem118, Dmem119,
               Dmem120, Dmem121, Dmem122, Dmem123, Dmem124, Dmem125, Dmem126, Dmem127;

    wire [31:0] decOut;
    wire [31:0] memReadOut;
    decoder5to32 writeDec (address, decOut);

    // 4 registers one decout
    register8bit rMem0   (clk, reset, memWrite, decOut[0],  writeData[31:24], Dmem0);
    register8bit rMem1   (clk, reset, memWrite, decOut[0],  writeData[23:16], Dmem1);   
    register8bit rMem2   (clk, reset, memWrite, decOut[0],  writeData[15: 8], Dmem2);   
    register8bit rMem3   (clk, reset, memWrite, decOut[0],  writeData[7 : 0], Dmem3); 

    register8bit rMem4   (clk, reset, memWrite, decOut[1],  writeData[31:24], Dmem4);
    register8bit rMem5   (clk, reset, memWrite, decOut[1],  writeData[23:16], Dmem5);  
    register8bit rMem6   (clk, reset, memWrite, decOut[1],  writeData[15: 8], Dmem6);  
    register8bit rMem7   (clk, reset, memWrite, decOut[1],  writeData[7 : 0], Dmem7); 

    register8bit rMem8   (clk, reset, memWrite, decOut[2],  writeData[31:24], Dmem8); 
    register8bit rMem9   (clk, reset, memWrite, decOut[2],  writeData[23:16], Dmem9);   
    register8bit rMem10  (clk, reset, memWrite, decOut[2],  writeData[15: 8], Dmem10);   
    register8bit rMem11  (clk, reset, memWrite, decOut[2],  writeData[7 : 0], Dmem11);   
    register8bit rMem12  (clk, reset, memWrite, decOut[3],  writeData[31:24], Dmem12); 
    register8bit rMem13  (clk, reset, memWrite, decOut[3],  writeData[23:16], Dmem13);  
    register8bit rMem14  (clk, reset, memWrite, decOut[3],  writeData[15: 8], Dmem14);  
    register8bit rMem15  (clk, reset, memWrite, decOut[3],  writeData[7 : 0], Dmem15); 
    register8bit rMem16  (clk, reset, memWrite, decOut[4],  writeData[31:24], Dmem16); 
    register8bit rMem17  (clk, reset, memWrite, decOut[4],  writeData[23:16], Dmem17);  
    register8bit rMem18  (clk, reset, memWrite, decOut[4],  writeData[15: 8], Dmem18);  
    register8bit rMem19  (clk, reset, memWrite, decOut[4],  writeData[7 : 0], Dmem19); 
    register8bit rMem20  (clk, reset, memWrite, decOut[5],  writeData[31:24], Dmem20);  
    register8bit rMem21  (clk, reset, memWrite, decOut[5],  writeData[23:16], Dmem21);  
    register8bit rMem22  (clk, reset, memWrite, decOut[5],  writeData[15: 8], Dmem22);  
    register8bit rMem23  (clk, reset, memWrite, decOut[5],  writeData[7 : 0], Dmem23); 
    register8bit rMem24  (clk, reset, memWrite, decOut[6],  writeData[31:24], Dmem24); 
    register8bit rMem25  (clk, reset, memWrite, decOut[6],  writeData[23:16], Dmem25);  
    register8bit rMem26  (clk, reset, memWrite, decOut[6],  writeData[15: 8], Dmem26);  
    register8bit rMem27  (clk, reset, memWrite, decOut[6],  writeData[7 : 0], Dmem27);
    register8bit rMem28  (clk, reset, memWrite, decOut[7],  writeData[31:24], Dmem28);  
    register8bit rMem29  (clk, reset, memWrite, decOut[7],  writeData[23:16], Dmem29);   
    register8bit rMem30  (clk, reset, memWrite, decOut[7],  writeData[15: 8], Dmem30);   
    register8bit rMem31  (clk, reset, memWrite, decOut[7],  writeData[7 : 0], Dmem31);  
    register8bit rMem32  (clk, reset, memWrite, decOut[8],  writeData[31:24], Dmem32);  
    register8bit rMem33  (clk, reset, memWrite, decOut[8],  writeData[23:16], Dmem33);   
    register8bit rMem34  (clk, reset, memWrite, decOut[8],  writeData[15: 8], Dmem34);   
    register8bit rMem35  (clk, reset, memWrite, decOut[8],  writeData[7 : 0], Dmem35);
    register8bit rMem36  (clk, reset, memWrite, decOut[9],  writeData[31:24], Dmem36);  
    register8bit rMem37  (clk, reset, memWrite, decOut[9],  writeData[23:16], Dmem37);   
    register8bit rMem38  (clk, reset, memWrite, decOut[9],  writeData[15: 8], Dmem38);   
    register8bit rMem39  (clk, reset, memWrite, decOut[9],  writeData[7 : 0], Dmem39);  
    register8bit rMem40  (clk, reset, memWrite, decOut[10], writeData[31:24], Dmem40);  
    register8bit rMem41  (clk, reset, memWrite, decOut[10], writeData[23:16], Dmem41);  
    register8bit rMem42  (clk, reset, memWrite, decOut[10], writeData[15: 8], Dmem42);  
    register8bit rMem43  (clk, reset, memWrite, decOut[10], writeData[7 : 0], Dmem43); 
    register8bit rMem44  (clk, reset, memWrite, decOut[11], writeData[31:24], Dmem44);                       
    register8bit rMem45  (clk, reset, memWrite, decOut[11], writeData[23:16], Dmem45);             
    register8bit rMem46  (clk, reset, memWrite, decOut[11], writeData[15: 8], Dmem46);             
    register8bit rMem47  (clk, reset, memWrite, decOut[11], writeData[7 : 0], Dmem47); 
    register8bit rMem48  (clk, reset, memWrite, decOut[12], writeData[31:24], Dmem48);  
    register8bit rMem49  (clk, reset, memWrite, decOut[12], writeData[23:16], Dmem49);  
    register8bit rMem50  (clk, reset, memWrite, decOut[12], writeData[15: 8], Dmem50);  
    register8bit rMem51  (clk, reset, memWrite, decOut[12], writeData[7 : 0], Dmem51); 
    register8bit rMem52  (clk, reset, memWrite, decOut[13], writeData[31:24], Dmem52);  
    register8bit rMem53  (clk, reset, memWrite, decOut[13], writeData[23:16], Dmem53);  
    register8bit rMem54  (clk, reset, memWrite, decOut[13], writeData[15: 8], Dmem54);  
    register8bit rMem55  (clk, reset, memWrite, decOut[13], writeData[7 : 0], Dmem55);  
    register8bit rMem56  (clk, reset, memWrite, decOut[14], writeData[31:24], Dmem56);                       
    register8bit rMem57  (clk, reset, memWrite, decOut[14], writeData[23:16], Dmem57);             
    register8bit rMem58  (clk, reset, memWrite, decOut[14], writeData[15: 8], Dmem58);             
    register8bit rMem59  (clk, reset, memWrite, decOut[14], writeData[7 : 0], Dmem59);  
    register8bit rMem60  (clk, reset, memWrite, decOut[15], writeData[31:24], Dmem60);
    register8bit rMem61  (clk, reset, memWrite, decOut[15], writeData[23:16], Dmem61); 
    register8bit rMem62  (clk, reset, memWrite, decOut[15], writeData[15: 8], Dmem62); 
    register8bit rMem63  (clk, reset, memWrite, decOut[15], writeData[7 : 0], Dmem63); 
    register8bit rMem64  (clk, reset, memWrite, decOut[16], writeData[31:24], Dmem64);
    register8bit rMem65  (clk, reset, memWrite, decOut[16], writeData[23:16], Dmem65); 
    register8bit rMem66  (clk, reset, memWrite, decOut[16], writeData[15: 8], Dmem66);
    register8bit rMem67  (clk, reset, memWrite, decOut[16], writeData[7 : 0], Dmem67);
    register8bit rMem68  (clk, reset, memWrite, decOut[17], writeData[31:24], Dmem68);
    register8bit rMem69  (clk, reset, memWrite, decOut[17], writeData[23:16], Dmem69);
    register8bit rMem70  (clk, reset, memWrite, decOut[17], writeData[15: 8], Dmem70);
    register8bit rMem71  (clk, reset, memWrite, decOut[17], writeData[7 : 0], Dmem71);
    register8bit rMem72  (clk, reset, memWrite, decOut[18], writeData[31:24], Dmem72);
    register8bit rMem73  (clk, reset, memWrite, decOut[18], writeData[23:16], Dmem73);
    register8bit rMem74  (clk, reset, memWrite, decOut[18], writeData[15: 8], Dmem74);
    register8bit rMem75  (clk, reset, memWrite, decOut[18], writeData[7 : 0], Dmem75);
    register8bit rMem76  (clk, reset, memWrite, decOut[19], writeData[31:24], Dmem76);
    register8bit rMem77  (clk, reset, memWrite, decOut[19], writeData[23:16], Dmem77);
    register8bit rMem78  (clk, reset, memWrite, decOut[19], writeData[15: 8], Dmem78);
    register8bit rMem79  (clk, reset, memWrite, decOut[19], writeData[7 : 0], Dmem79);
    register8bit rMem80  (clk, reset, memWrite, decOut[20], writeData[31:24], Dmem80);
    register8bit rMem81  (clk, reset, memWrite, decOut[20], writeData[23:16], Dmem81);
    register8bit rMem82  (clk, reset, memWrite, decOut[20], writeData[15: 8], Dmem82);
    register8bit rMem83  (clk, reset, memWrite, decOut[20], writeData[7 : 0], Dmem83);
    register8bit rMem84  (clk, reset, memWrite, decOut[21], writeData[31:24], Dmem84);
    register8bit rMem85  (clk, reset, memWrite, decOut[21], writeData[23:16], Dmem85);
    register8bit rMem86  (clk, reset, memWrite, decOut[21], writeData[15: 8], Dmem86);
    register8bit rMem87  (clk, reset, memWrite, decOut[21], writeData[7 : 0], Dmem87);
    register8bit rMem88  (clk, reset, memWrite, decOut[22], writeData[31:24], Dmem88);
    register8bit rMem89  (clk, reset, memWrite, decOut[22], writeData[23:16], Dmem89);
    register8bit rMem90  (clk, reset, memWrite, decOut[22], writeData[15: 8], Dmem90);
    register8bit rMem91  (clk, reset, memWrite, decOut[22], writeData[7 : 0], Dmem91);
    register8bit rMem92  (clk, reset, memWrite, decOut[23], writeData[31:24], Dmem92);
    register8bit rMem93  (clk, reset, memWrite, decOut[23], writeData[23:16], Dmem93);
    register8bit rMem94  (clk, reset, memWrite, decOut[23], writeData[15: 8], Dmem94);
    register8bit rMem95  (clk, reset, memWrite, decOut[23], writeData[7 : 0], Dmem95);
    register8bit rMem96  (clk, reset, memWrite, decOut[24], writeData[31:24], Dmem96);
    register8bit rMem97  (clk, reset, memWrite, decOut[24], writeData[23:16], Dmem97);
    register8bit rMem98  (clk, reset, memWrite, decOut[24], writeData[15: 8], Dmem98);
    register8bit rMem99  (clk, reset, memWrite, decOut[24], writeData[7 : 0], Dmem99);
    register8bit rMem100 (clk, reset, memWrite, decOut[25], writeData[31:24], Dmem100);
    register8bit rMem101 (clk, reset, memWrite, decOut[25], writeData[23:16], Dmem101);
    register8bit rMem102 (clk, reset, memWrite, decOut[25], writeData[15: 8], Dmem102);
    register8bit rMem103 (clk, reset, memWrite, decOut[25], writeData[7 : 0], Dmem103);
    register8bit rMem104 (clk, reset, memWrite, decOut[26], writeData[31:24], Dmem104);
    register8bit rMem105 (clk, reset, memWrite, decOut[26], writeData[23:16], Dmem105);
    register8bit rMem106 (clk, reset, memWrite, decOut[26], writeData[15: 8], Dmem106);
    register8bit rMem107 (clk, reset, memWrite, decOut[26], writeData[7 : 0], Dmem107);
    register8bit rMem108 (clk, reset, memWrite, decOut[27], writeData[31:24], Dmem108);
    register8bit rMem109 (clk, reset, memWrite, decOut[27], writeData[23:16], Dmem109);
    register8bit rMem110 (clk, reset, memWrite, decOut[27], writeData[15: 8], Dmem110);
    register8bit rMem111 (clk, reset, memWrite, decOut[27], writeData[7 : 0], Dmem111);
    register8bit rMem112 (clk, reset, memWrite, decOut[28], writeData[31:24], Dmem112);
    register8bit rMem113 (clk, reset, memWrite, decOut[28], writeData[23:16], Dmem113);
    register8bit rMem114 (clk, reset, memWrite, decOut[28], writeData[15: 8], Dmem114);
    register8bit rMem115 (clk, reset, memWrite, decOut[28], writeData[7 : 0], Dmem115);
    
    register8bit rMem116 (clk, reset, memWrite, decOut[29], writeData[31:24], Dmem116);
    register8bit rMem117 (clk, reset, memWrite, decOut[29], writeData[23:16], Dmem117);
    register8bit rMem118 (clk, reset, memWrite, decOut[29], writeData[15: 8], Dmem118);
    register8bit rMem119 (clk, reset, memWrite, decOut[29], writeData[7 : 0], Dmem119);

    register8bit rMem120 (clk, reset, 1'b1, 1'b1, 8'b00000000, Dmem120); //Fibo-2
    register8bit rMem121 (clk, reset, 1'b1, 1'b1, 8'b00000000, Dmem121);
    register8bit rMem122 (clk, reset, 1'b1, 1'b1, 8'b00000000, Dmem122);
    register8bit rMem123 (clk, reset, 1'b1, 1'b1, 8'b00000001, Dmem123);

    register8bit rMem124 (clk, reset, 1'b1, 1'b1, 8'b00000000, Dmem124);//Fibo-1
    register8bit rMem125 (clk, reset, 1'b1, 1'b1, 8'b00000000, Dmem125);
    register8bit rMem126 (clk, reset, 1'b1, 1'b1, 8'b00000000, Dmem126);
    register8bit rMem127 (clk, reset, 1'b1, 1'b1, 8'b00000001, Dmem127);

    mux128to1_IM muxMemRead  (Dmem0,   Dmem1,   Dmem2,   Dmem3,   Dmem4,   Dmem5,   Dmem6,   Dmem7,   
                             Dmem8,   Dmem9,   Dmem10,  Dmem11,  Dmem12,  Dmem13,  Dmem14,  Dmem15,   
                             Dmem16,  Dmem17,  Dmem18,  Dmem19,  Dmem20,  Dmem21,  Dmem22,  Dmem23, 
                             Dmem24,  Dmem25,  Dmem26,  Dmem27,  Dmem28,  Dmem29,  Dmem30,  Dmem31, 
                             Dmem32,  Dmem33,  Dmem34,  Dmem35,  Dmem36,  Dmem37,  Dmem38,  Dmem39, 
                             Dmem40,  Dmem41,  Dmem42,  Dmem43,  Dmem44,  Dmem45,  Dmem46,  Dmem47, 
                             Dmem48,  Dmem49,  Dmem50,  Dmem51,  Dmem52,  Dmem53,  Dmem54,  Dmem55, 
                             Dmem56,  Dmem57,  Dmem58,  Dmem59,  Dmem60,  Dmem61,  Dmem62,  Dmem63, 
                             Dmem64,  Dmem65,  Dmem66,  Dmem67,  Dmem68,  Dmem69,  Dmem70,  Dmem71, 
                             Dmem72,  Dmem73,  Dmem74,  Dmem75,  Dmem76,  Dmem77,  Dmem78,  Dmem79, 
                             Dmem80,  Dmem81,  Dmem82,  Dmem83,  Dmem84,  Dmem85,  Dmem86,  Dmem87, 
                             Dmem88,  Dmem89,  Dmem90,  Dmem91,  Dmem92,  Dmem93,  Dmem94,  Dmem95, 
                             Dmem96,  Dmem97,  Dmem98,  Dmem99,  Dmem100, Dmem101, Dmem102, Dmem103,
                             Dmem104, Dmem105, Dmem106, Dmem107, Dmem108, Dmem109, Dmem110, Dmem111,
                             Dmem112, Dmem113, Dmem114, Dmem115, Dmem116, Dmem117, Dmem118, Dmem119,
                             Dmem120, Dmem121, Dmem122, Dmem123, Dmem124, Dmem125, Dmem126, Dmem127,
                             address, memReadOut);
    mux2to1_32bits muxReadIM (32'b0, memReadOut, memRead, memOut); 							
endmodule