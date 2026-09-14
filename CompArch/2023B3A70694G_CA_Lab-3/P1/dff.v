/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

 
module D_ff(input clk, input reset, input wr, input en , input d, output q);    
    wire dbar, resetbar, out1, out2, qbar, dr;
       
    //=========================================================================
    //Nature of D-FF's structural Verilog code
    //Structural code mimic or simulate the Gate level structure of the circuit
    //=========================================================================
    
    not  n0(resetbar, reset); 
    not  n1(dbar, d);
    nand nand1(out1, d, wr, clk, en);
    nand nand2(out2, dbar, wr, clk, en);
    nand nand3(q, out1, qbar);
    nand nand4(qbar, out2, q, resetbar);
endmodule