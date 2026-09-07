`include "MinMaxProcessor.v"

module testbench();
    //inputs
    reg clk, reset, memWrite;
    reg loadPc, pcUpdate;
    reg loadMin, loadMax;
    reg loadLimit, limitUpdate;

     //outputs
    wire [15:0] memOut;
    wire [15:0] minData;
    wire [15:0] maxData;
    wire stop;

    MinMaxProcessor processor(clk, reset, memOut, minData, maxData, stop);

    always
    begin
         #5 clk=~clk;
    end

    initial

    begin
         clk=0;
         reset=1; //memory written 

         $dumpfile("2023B3A70694G_CA_Lab-2.vcd"); 
         $dumpvars(0,testbench);

         #10 reset=0;


         #200 $finish;
    end
endmodule