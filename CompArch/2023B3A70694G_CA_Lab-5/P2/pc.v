/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

module D_ff_PC(input clk, input reset, input regWrite, input d, output reg q);
    always@(posedge clk) //negedge clk
    begin
        if(reset == 1'b1)
        begin
            q <= 0;
        end
        else if(regWrite == 1'b1)
        begin
            q <= d;
        end
    end
endmodule

module register32bit_PC(input clk, input reset, input regWrite, input [31:0] writeData, output [31:0] outR);
    D_ff_PC d0  (clk, reset, regWrite, writeData[0],  outR[0]);
    D_ff_PC d1  (clk, reset, regWrite, writeData[1],  outR[1]);
    D_ff_PC d2  (clk, reset, regWrite, writeData[2],  outR[2]);
    D_ff_PC d3  (clk, reset, regWrite, writeData[3],  outR[3]);
    D_ff_PC d4  (clk, reset, regWrite, writeData[4],  outR[4]);
    D_ff_PC d5  (clk, reset, regWrite, writeData[5],  outR[5]);
    D_ff_PC d6  (clk, reset, regWrite, writeData[6],  outR[6]);
    D_ff_PC d7  (clk, reset, regWrite, writeData[7],  outR[7]);
    D_ff_PC d8  (clk, reset, regWrite, writeData[8],  outR[8]);
    D_ff_PC d9  (clk, reset, regWrite, writeData[9],  outR[9]);
    D_ff_PC d10 (clk, reset, regWrite, writeData[10], outR[10]);
    D_ff_PC d11 (clk, reset, regWrite, writeData[11], outR[11]);
    D_ff_PC d12 (clk, reset, regWrite, writeData[12], outR[12]);
    D_ff_PC d13 (clk, reset, regWrite, writeData[13], outR[13]);
    D_ff_PC d14 (clk, reset, regWrite, writeData[14], outR[14]);
    D_ff_PC d15 (clk, reset, regWrite, writeData[15], outR[15]);
    D_ff_PC d16 (clk, reset, regWrite, writeData[16], outR[16]);
    D_ff_PC d17 (clk, reset, regWrite, writeData[17], outR[17]);
    D_ff_PC d18 (clk, reset, regWrite, writeData[18], outR[18]);
    D_ff_PC d19 (clk, reset, regWrite, writeData[19], outR[19]);
    D_ff_PC d20 (clk, reset, regWrite, writeData[20], outR[20]);
    D_ff_PC d21 (clk, reset, regWrite, writeData[21], outR[21]);
    D_ff_PC d22 (clk, reset, regWrite, writeData[22], outR[22]);
    D_ff_PC d23 (clk, reset, regWrite, writeData[23], outR[23]);
    D_ff_PC d24 (clk, reset, regWrite, writeData[24], outR[24]);
    D_ff_PC d25 (clk, reset, regWrite, writeData[25], outR[25]);
    D_ff_PC d26 (clk, reset, regWrite, writeData[26], outR[26]);
    D_ff_PC d27 (clk, reset, regWrite, writeData[27], outR[27]);
    D_ff_PC d28 (clk, reset, regWrite, writeData[28], outR[28]);
    D_ff_PC d29 (clk, reset, regWrite, writeData[29], outR[29]);
    D_ff_PC d30 (clk, reset, regWrite, writeData[30], outR[30]);
    D_ff_PC d31 (clk, reset, regWrite, writeData[31], outR[31]);
endmodule