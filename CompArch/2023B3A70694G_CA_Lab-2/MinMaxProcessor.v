`include "MEM.v"
`include "MinReg.v"
`include "MaxReg.v"
`include "Limit.v"
`include "comparator.v"
`include "mux2to1_5bits.v"
`include "mux2to1_16bits.v"
`include "adder.v"
`include "PC.v"
`include "tristate16bit.v"
`include "controller.v"

module MinMaxProcessor(input clk, input reset, output [15:0] memOut, output [15:0] minData, output [15:0] maxData, output stop);


    wire [15:0] pc;
    wire [15:0] nextpc;
    wire [15:0] pcAdderOutput;

    wire [15:0] maxTsbout;
    wire [15:0] nextMaxData;

    wire [15:0] minTsbout;
    wire [15:0] nextMinData;
    wire min_lesser_than, min_equal, min_greater_than;
    wire max_lesser_than, max_equal, max_greater_than;

    wire [15:0] limitValue;
    wire [15:0] nextLimitValue;
    wire [15:0] limitAdderOutput;
    
    wire memWrite, loadPc, loadMin, loadMax, loadLimit, pcUpdate, minUpdate, maxUpdate, limitUpdate;

    memory mem1 (clk, reset, pc[5:1], memWrite, memOut); //pc is incremented by 2 every cycle, so pc[5:1] is used to access memory locations 0-10
    //reads memory and outputs that value into memOut which is compared to minData and maxData

    adder pcAdder (pc, 16'd2, pcAdderOutput); //adding 2 because that's what is shown in the diagram 
    mux2to1_16bits PCmux (pcAdderOutput, 16'd0, loadPc, nextpc); //at reset loadPc = 1, so nextpc = 0
    PC_reg p1(clk, reset, pcUpdate, nextpc, pc); //pc starts from 0 then increments by 2 every cycle, until stop = 1

    triStateBuffer16bit minT (memOut, min_lesser_than, minTsbout);
    mux2to1_16bits minMux (minTsbout, 16'hFFFF, loadMin, nextMinData); 
    MinReg min1 (clk, reset, minUpdate, nextMinData, minData);
    Comparator_16bits minC (memOut, minData, min_lesser_than, min_equal, min_greater_than);
    //when a smaller element is found, min_lesser_than = 1 so the the tristate buffer can be enabled and loadMin = 0 so that the buffer output is selected by mux

    triStateBuffer16bit maxT (memOut, max_greater_than, maxTsbout);
    mux2to1_16bits maxMux (maxTsbout, 16'h0000, loadMax, nextMaxData);
    MaxReg max1 (clk, reset, maxUpdate, nextMaxData, maxData); //maxUpdate signal is same as the max_greater_than signal, so register is updated with the new max
    Comparator_16bits maxC (memOut, maxData, max_lesser_than, max_equal, max_greater_than);
    
    mux2to1_16bits limitMux (limitAdderOutput, 16'd10, loadLimit, nextLimitValue);
    Limit_reg l1 (clk, reset, limitUpdate, nextLimitValue, limitValue, stop);
    adder limitAdder (limitValue, -16'd1, limitAdderOutput);
    
    controller c (reset, stop, min_lesser_than, max_greater_than, memWrite, loadPc, loadMin, loadMax, loadLimit, pcUpdate, minUpdate, maxUpdate, limitUpdate);

endmodule

/*
PC[5:0] values - 
000000 - 0
000010 - 2
000100 - 4
000110 - 6
001000 - 8
001010 - 10
001100 - 12
001110 - 14
010000 - 16
010010 - 18
010100 - 20
PC[5:1] values - 0,1,2,3,4,5,6,7,8,9,10
*/




