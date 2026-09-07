/*###################################################################################
Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/


module Dff4Mem(input clk, input reset, input memWrite, input decOut1b, input d, output reg q);
  always @(reset, posedge clk)
    begin
        if(reset == 1'b1)
        begin
            q <= d; //memory written at reset 
        end
        else if(memWrite ==1'b1 && decOut1b == 1'b1)
        begin
            q <= d;
        end
    end
endmodule
//8bit register (technically not byte addressable memory since one 5 bit address is used to address 2 consecutive 8 bits memory locations, effectively addressing 16 bits of memory)
module register4mem(input clk, input reset, input memWrite,  input decOut1b, input [7:0] inR, output [7:0] outR);
    Dff4Mem d0 (clk, reset, memWrite,  decOut1b, inR[0],  outR[0]);
    Dff4Mem d1 (clk, reset, memWrite,  decOut1b, inR[1],  outR[1]);
    Dff4Mem d2 (clk, reset, memWrite,  decOut1b, inR[2],  outR[2]);
    Dff4Mem d3 (clk, reset, memWrite,  decOut1b, inR[3],  outR[3]);
    Dff4Mem d4 (clk, reset, memWrite,  decOut1b, inR[4],  outR[4]);
    Dff4Mem d5 (clk, reset, memWrite,  decOut1b, inR[5],  outR[5]);
    Dff4Mem d6 (clk, reset, memWrite,  decOut1b, inR[6],  outR[6]);
    Dff4Mem d7 (clk, reset, memWrite,  decOut1b, inR[7],  outR[7]);
endmodule
//memory contains 32 locations, each location addresses a 16 bit word i.e 2 consecutive bytes (16 bits). Memory size = 32*2 = 64 bytes
//5 address lines - 32 addressable locations
module decoder5to32(input [4:0] decIn, output reg [31:0] decOut);
    always@(decIn)
    begin
        case(decIn)
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
//address line is used as the select for mux, the 64 byte addressable memory are all inputs for the mux, 2 of which are selected and concatenated to form a 16 bit output (word)
module mux64to1_mem(input [7:0] in0,   input [7:0] in1,   input [7:0] in2,   input [7:0] in3,
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
                    input [4:0] select, output reg [15:0] muxOut);
    always@(in0,   in1,   in2,   in3,   in4,   in5,   in6,   in7, 
            in8,   in9,   in10,  in11,  in12,  in13,  in14,  in15,   
            in16,  in17,  in18,  in19,  in20,  in21,  in22,  in23, 
            in24,  in25,  in26,  in27,  in28,  in29,  in30,  in31, 
            in32,  in33,  in34,  in35,  in36,  in37,  in38,  in39, 
            in40,  in41,  in42,  in43,  in44,  in45,  in46,  in47, 
            in48,  in49,  in50,  in51,  in52,  in53,  in54,  in55, 
            in56,  in57,  in58,  in59,  in60,  in61,  in62,  in63, 
            select)
    begin
        case(select)
            5'd0:  muxOut = {in0,   in1 };
            5'd1:  muxOut = {in2,   in3 };
            5'd2:  muxOut = {in4,   in5 };
            5'd3:  muxOut = {in6,   in7 };
            5'd4:  muxOut = {in8,   in9 };
            5'd5:  muxOut = {in10,  in11};
            5'd6:  muxOut = {in12,  in13};
            5'd7:  muxOut = {in14,  in15};
            5'd8:  muxOut = {in16,  in17};
            5'd9:  muxOut = {in18,  in19};
            5'd10: muxOut = {in20,  in21};
            5'd11: muxOut = {in22,  in23};
            5'd12: muxOut = {in24,  in25};
            5'd13: muxOut = {in26,  in27}; 
            5'd14: muxOut = {in28,  in29}; 
            5'd15: muxOut = {in30,  in31};
            5'd16: muxOut = {in32,  in33};
            5'd17: muxOut = {in34,  in35};
            5'd18: muxOut = {in36,  in37};
            5'd19: muxOut = {in38,  in39};
            5'd20: muxOut = {in40,  in41};
            5'd21: muxOut = {in42,  in43};
            5'd22: muxOut = {in44,  in45};
            5'd23: muxOut = {in46,  in47};
            5'd24: muxOut = {in48,  in49};
            5'd25: muxOut = {in50,  in51};
            5'd26: muxOut = {in52,  in53};
            5'd27: muxOut = {in54,  in55};
            5'd28: muxOut = {in56,  in57};
            5'd29: muxOut = {in58,  in59};
            5'd30: muxOut = {in60,  in61};
            5'd31: muxOut = {in62,  in63};
        endcase
    end
endmodule

module memory(input clk, input reset, input [4:0] address, input memWrite, output [15:0] memOut);
    
    wire [7:0] outR0,   outR1,   outR2,   outR3,   outR4,   outR5,   outR6,   outR7,   
               outR8,   outR9,   outR10,  outR11,  outR12,  outR13,  outR14,  outR15,   
               outR16,  outR17,  outR18,  outR19,  outR20,  outR21,  outR22,  outR23, 
               outR24,  outR25,  outR26,  outR27,  outR28,  outR29,  outR30,  outR31, 
               outR32,  outR33,  outR34,  outR35,  outR36,  outR37,  outR38,  outR39, 
               outR40,  outR41,  outR42,  outR43,  outR44,  outR45,  outR46,  outR47, 
               outR48,  outR49,  outR50,  outR51,  outR52,  outR53,  outR54,  outR55, 
               outR56,  outR57,  outR58,  outR59,  outR60,  outR61,  outR62,  outR63;

     wire [15:0] imOut;
     wire [31:0] decOut;

    decoder5to32 writeDec (address, decOut);
                            //BEGIN of the Fibbo program
    register4mem regMem0   (clk, reset, memWrite, decOut[0], 8'b0000_0000, outR0); //48
    register4mem regMem1   (clk, reset, memWrite, decOut[0], 8'b0011_0000, outR1);  

    register4mem regMem2   (clk, reset, memWrite, decOut[1], 8'b0000_0000, outR2); //50
    register4mem regMem3   (clk, reset, memWrite, decOut[1], 8'b0011_0010, outR3); 

    register4mem regMem4   (clk, reset, memWrite, decOut[2], 8'b0000_0000, outR4);  //52
    register4mem regMem5   (clk, reset, memWrite, decOut[2], 8'b0011_0100, outR5);  

    register4mem regMem6   (clk, reset, memWrite, decOut[3], 8'b0000_0000, outR6);  //1
    register4mem regMem7   (clk, reset, memWrite, decOut[3], 8'b0000_0001, outR7);

    register4mem regMem8   (clk, reset, memWrite, decOut[4], 8'b0000_0000, outR8);  // 54
    register4mem regMem9   (clk, reset, memWrite, decOut[4], 8'b0011_0110, outR9);

    register4mem regMem10  (clk, reset, memWrite, decOut[5], 8'b0000_0000, outR10);   //55
    register4mem regMem11  (clk, reset, memWrite, decOut[5], 8'b0011_0111, outR11);

    register4mem regMem12  (clk, reset, memWrite, decOut[6], 8'b0000_0000, outR12);  //56
    register4mem regMem13  (clk, reset, memWrite, decOut[6], 8'b0011_1000, outR13);

    register4mem regMem14  (clk, reset, memWrite, decOut[7], 8'b0000_0000, outR14);  //54
    register4mem regMem15  (clk, reset, memWrite, decOut[7], 8'b0011_0110, outR15);

    register4mem regMem16  (clk, reset, memWrite, decOut[8], 8'b0000_0000, outR16); //58
    register4mem regMem17  (clk, reset, memWrite, decOut[8], 8'b0011_1010, outR17);  

    register4mem regMem18  (clk, reset, memWrite, decOut[9], 8'b0000_0000, outR18); //59
    register4mem regMem19  (clk, reset, memWrite, decOut[9], 8'b0011_1011, outR19); 
                                                                        
    register4mem regMem20  (clk, reset, memWrite, decOut[10], 8'b0000_0000, outR20);  // 60
    register4mem regMem21  (clk, reset, memWrite, decOut[10], 8'b0011_1100, outR21); 
                              //END of the Data
    register4mem regMem22  (clk, reset, memWrite, decOut[11], 8'd0, outR22);  
    register4mem regMem23  (clk, reset, memWrite, decOut[11], 8'd0, outR23);

    register4mem regMem24  (clk, reset, memWrite, decOut[12], 8'd0, outR24);
    register4mem regMem25  (clk, reset, memWrite, decOut[12], 8'd0, outR25);

    register4mem regMem26  (clk, reset, memWrite, decOut[13], 8'd0, outR26);  
    register4mem regMem27  (clk, reset, memWrite, decOut[13], 8'd0, outR27);

    register4mem regMem28  (clk, reset, memWrite, decOut[14], 8'd0, outR28);  
    register4mem regMem29  (clk, reset, memWrite, decOut[14], 8'd0, outR29);

    register4mem regMem30  (clk, reset, memWrite, decOut[15], 8'd0, outR30);   
    register4mem regMem31  (clk, reset, memWrite, decOut[15], 8'd0, outR31);  

    register4mem regMem32  (clk, reset, memWrite, decOut[16], 8'd0, outR32); 
    register4mem regMem33  (clk, reset, memWrite, decOut[16], 8'd0, outR33);

    register4mem regMem34  (clk, reset, memWrite, decOut[17], 8'd0, outR34);   
    register4mem regMem35  (clk, reset, memWrite, decOut[17], 8'd0, outR35); 

    register4mem regMem36  (clk, reset, memWrite, decOut[18], 8'd0, outR36); 
    register4mem regMem37  (clk, reset, memWrite, decOut[18], 8'd0, outR37);   

    register4mem regMem38  (clk, reset, memWrite, decOut[19], 8'd0, outR38);   
    register4mem regMem39  (clk, reset, memWrite, decOut[19], 8'd0, outR39);  

    register4mem regMem40  (clk, reset, memWrite, decOut[20], 8'h00, outR40); 
    register4mem regMem41  (clk, reset, memWrite, decOut[20], 8'h00, outR41);

    register4mem regMem42  (clk, reset, memWrite, decOut[21],  8'h00, outR42);  
    register4mem regMem43  (clk, reset, memWrite, decOut[21], 8'h00, outR43); 

    register4mem regMem44  (clk, reset, memWrite, decOut[22], 8'h00, outR44);                      
    register4mem regMem45  (clk, reset, memWrite, decOut[22], 8'h00, outR45);

    register4mem regMem46  (clk, reset, memWrite, decOut[23], 8'h00, outR46);             
    register4mem regMem47  (clk, reset, memWrite, decOut[23], 8'h00, outR47);

    register4mem regMem48  (clk, reset, memWrite, decOut[24], 8'b0000_0000, outR48); 
    register4mem regMem49  (clk, reset, memWrite, decOut[24], 8'b0000_0001, outR49); 

    register4mem regMem50  (clk, reset, memWrite, decOut[25], 8'b0000_0000, outR50);  
    register4mem regMem51  (clk, reset, memWrite, decOut[25], 8'b0000_0001, outR51); 

    register4mem regMem52  (clk, reset, memWrite, decOut[26], 8'b0000_0000, outR52);  
    register4mem regMem53  (clk, reset, memWrite, decOut[26], 8'b0000_0000, outR53);

    register4mem regMem54  (clk, reset, memWrite, decOut[27], 8'b0000_0000, outR54);  
    register4mem regMem55  (clk, reset, memWrite, decOut[27], 8'b0000_0000, outR55);  

    register4mem regMem56  (clk, reset, memWrite, decOut[28], 8'b0000_0000, outR56);                   
    register4mem regMem57  (clk, reset, memWrite, decOut[28], 8'b0000_0000, outR57);

    register4mem regMem58  (clk, reset, memWrite, decOut[29], 8'b0000_0000, outR58);         
    register4mem regMem59  (clk, reset, memWrite, decOut[29], 8'b0000_0000, outR59);  

    register4mem regMem60  (clk, reset, memWrite, decOut[30], 8'b0000_0000, outR60); 
    register4mem regMem61  (clk, reset, memWrite,decOut[30], 8'b0000_0000, outR61);

    register4mem regMem62  (clk, reset, memWrite, decOut[31], 8'h00, outR62); 
    register4mem regMem63  (clk, reset, memWrite, decOut[31], 8'h00, outR63); 

    
    
    mux64to1_mem muxIM (outR0,   outR1,   outR2,   outR3,   outR4,   outR5,   outR6,   outR7,   
                        outR8,   outR9,   outR10,  outR11,  outR12,  outR13,  outR14,  outR15,   
                        outR16,  outR17,  outR18,  outR19,  outR20,  outR21,  outR22,  outR23, 
                        outR24,  outR25,  outR26,  outR27,  outR28,  outR29,  outR30,  outR31, 
                        outR32,  outR33,  outR34,  outR35,  outR36,  outR37,  outR38,  outR39, 
                        outR40,  outR41,  outR42,  outR43,  outR44,  outR45,  outR46,  outR47, 
                        outR48,  outR49,  outR50,  outR51,  outR52,  outR53,  outR54,  outR55, 
                        outR56,  outR57,  outR58,  outR59,  outR60,  outR61,  outR62,  outR63, 
                        address, memOut);
    							
endmodule