/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository.
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
module adder(input [15:0] in1, input [15:0] in2, output reg [15:0] adderOut);
      always @(*) begin
        adderOut = in1 + in2;
      end
      //must use always block since output is a reg type 
endmodule

