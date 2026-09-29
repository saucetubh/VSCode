/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
`include "topModule.v"
module testbench();
	reg clk;
	reg reset;
	//wire [31:0] result;
	singleCycle SC(clk, reset);

	always
	#5 clk=~clk;
	
	initial
	begin
        $dumpfile("2023B3A70694G__SCTribo.vcd"); 
        $dumpvars(0,testbench);

		clk=1; reset=1;//clk=0; reset=1;
		#10  reset=0;	
		//$monitor($time," %x ",result);
		#810 $finish;
	end

      
endmodule