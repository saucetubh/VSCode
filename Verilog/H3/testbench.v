`include "FSM.v"

module testbench;


reg clk, reset, in;
wire out;

FSMQ2 f(clk, reset, in, out);

always #5 clk = ~clk;

wire [7:0] state_alias;
assign state_alias = (f.state == 2'b00) ? "A" : (f.state == 2'b01) ? "B" : (f.state == 2'b10) ? "C" : "D";

initial begin
    $dumpfile("out.vcd");
    $dumpvars(0, testbench);

    clk = 0; reset = 1; in = 0;

    #10 reset = 0; in = 0;

        #10 in = 1; 

        #10 reset = 1; in = 0; 

        #10 reset = 0; in = 1; 

        #10 in = 0;

        #10 in = 1; 

        #10 $finish;

end

initial begin
    $monitor("Time = %0t, clk = %b, reset = %b, in = %b, state = %c, out = %b", $time, clk, reset, in, state_alias, out);
end

endmodule