/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

`include "topModule_registerFile.v"

module testbench();

    //inputs
    reg clk,reset,regWrite;
    reg [4:0] srcRegA,srcRegB,destReg;
    reg [31:0] writeData;
 
     //outputs
    wire [31:0] outBusA;
    wire [31:0] outBusB;
    registerFile uut(clk,reset,regWrite,srcRegA,srcRegB,destReg,writeData,outBusA,outBusB); 
   
    always 
    begin 
         #5 clk=~clk; 
    end
    
    initial
    
    begin 
         clk=0; 
         reset=1; 
         srcRegA=5'd0; 
         srcRegB=5'd1; 
         $dumpfile("2023B3A70694G_CA_Lab3.vcd"); 
         $dumpvars(0,testbench);
        
         #10 reset=0; regWrite=1; destReg=5'd2; writeData=32'd2; srcRegA=5'd0; srcRegB=5'd1;
         #10 destReg=5'd4; writeData=32'd4; srcRegA=5'd0; srcRegB=5'd1;
         #10 destReg=5'd6; writeData=32'd6; srcRegA=5'd0; srcRegB=5'd1;
         #10 destReg=5'd8; writeData=32'd8; srcRegA=5'd0; srcRegB=5'd1;
         #10 regWrite=0; srcRegA=5'd2; srcRegB=5'd8;
         #10 srcRegA=5'd4; srcRegB=5'd6;
    
         #10 $finish;
    end
endmodule 