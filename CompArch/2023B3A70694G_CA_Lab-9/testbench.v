/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/

`include "topModule.v"

module pipeline_hdu_testbench();
	reg clk;
	reg reset;
	
	pipelinedDatapath pipeDataPathHDU(clk, reset);

	always
	#5 clk=~clk;
	
	initial
	begin

        $dumpfile("2023B3A70694G_PipelinedMIPS_HDU.vcd"); 
        $dumpvars(0, pipeline_hdu_testbench);
		//clk=0; reset=1;
		clk=1; reset=1;
		#10  reset=0;	

		#600 $finish;
	end
endmodule
