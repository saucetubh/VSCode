/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

`include "dff.v"

//32 bit register
module register32bit(input clk, input reset, input regWrite, input en, input[31:0] writeData, output[31:0] outBus);
//A N-bit register consists of N D flip-flops, each storing a bit of data.
//In this case, there will be 32 instances of D_ff, each taking writeData[0]...[31] as the d input and outBus[0]...[31] as the q output

    D_ff dff0(clk, reset, regWrite, en, writeData[0], outBus[0]);
    D_ff dff1(clk, reset, regWrite, en, writeData[1], outBus[1]);
    D_ff dff2(clk, reset, regWrite, en, writeData[2], outBus[2]);
    D_ff dff3(clk, reset, regWrite, en, writeData[3], outBus[3]);
    D_ff dff4(clk, reset, regWrite, en, writeData[4], outBus[4]);
    D_ff dff5(clk, reset, regWrite, en, writeData[5], outBus[5]);
    D_ff dff6(clk, reset, regWrite, en, writeData[6], outBus[6]);
    D_ff dff7(clk, reset, regWrite, en, writeData[7], outBus[7]);
    D_ff dff8(clk, reset, regWrite, en, writeData[8], outBus[8]);
    D_ff dff9(clk, reset, regWrite, en, writeData[9], outBus[9]);
    D_ff dff10(clk, reset, regWrite, en, writeData[10], outBus[10]);
    D_ff dff11(clk, reset, regWrite, en, writeData[11], outBus[11]);
    D_ff dff12(clk, reset, regWrite, en, writeData[12], outBus[12]);
    D_ff dff13(clk, reset, regWrite, en, writeData[13], outBus[13]);
    D_ff dff14(clk, reset, regWrite, en, writeData[14], outBus[14]);
    D_ff dff15(clk, reset, regWrite, en, writeData[15], outBus[15]);
    D_ff dff16(clk, reset, regWrite, en, writeData[16], outBus[16]);
    D_ff dff17(clk, reset, regWrite, en, writeData[17], outBus[17]);
    D_ff dff18(clk, reset, regWrite, en, writeData[18], outBus[18]);
    D_ff dff19(clk, reset, regWrite, en, writeData[19], outBus[19]);
    D_ff dff20(clk, reset, regWrite, en, writeData[20], outBus[20]);
    D_ff dff21(clk, reset, regWrite, en, writeData[21], outBus[21]);
    D_ff dff22(clk, reset, regWrite, en, writeData[22], outBus[22]);
    D_ff dff23(clk, reset, regWrite, en, writeData[23], outBus[23]);
    D_ff dff24(clk, reset, regWrite, en, writeData[24], outBus[24]);
    D_ff dff25(clk, reset, regWrite, en, writeData[25], outBus[25]);
    D_ff dff26(clk, reset, regWrite, en, writeData[26], outBus[26]);
    D_ff dff27(clk, reset, regWrite, en, writeData[27], outBus[27]);
    D_ff dff28(clk, reset, regWrite, en, writeData[28], outBus[28]);
    D_ff dff29(clk, reset, regWrite, en, writeData[29], outBus[29]);
    D_ff dff30(clk, reset, regWrite, en, writeData[30], outBus[30]);
    D_ff dff31(clk, reset, regWrite, en, writeData[31], outBus[31]);

  
 
endmodule