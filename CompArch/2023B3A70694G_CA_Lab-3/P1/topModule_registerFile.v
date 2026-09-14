/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

`include "decoder5to32bit.v"
`include "mux32to1_32bit.v"
`include "registerSet32.v"

module registerFile(input clk, input reset, input regWrite, input[4:0] srcRegA, input[4:0] srcRegB, input[4:0] destReg, input[31:0] writeData, output[31:0] outBusA, output[31:0] outBusB);
      
    wire [31:0] decOut;
    wire [31:0] outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15, outR16, outR17, outR18, outR19,
        outR20, outR21, outR22, outR23, outR24, outR25, outR26, outR27, outR28, outR29, outR30, outR31;

    decoder_5to32 dc(destReg, decOut);
    registerSet rs321(clk, reset, regWrite, decOut, writeData, outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15, outR16, outR17, outR18, outR19, outR20, outR21, outR22, outR23, outR24, outR25, outR26, outR27, outR28, outR29, outR30, outR31);
    Mux32to1_32bit m32132b1(outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15, outR16, outR17, outR18, outR19, outR20, outR21, outR22, outR23, outR24, outR25, outR26, outR27, outR28, outR29, outR30, outR31, srcRegA, outBusA);
    Mux32to1_32bit m32132b2(outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15, outR16, outR17, outR18, outR19, outR20, outR21, outR22, outR23, outR24, outR25, outR26, outR27, outR28, outR29, outR30, outR31, srcRegB, outBusB);


endmodule
