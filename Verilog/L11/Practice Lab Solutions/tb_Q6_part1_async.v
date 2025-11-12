`include "Q6_part1_async.v"
module counter_testbench();
reg clk, reset;
wire [2:0] Q;

counter dut(clk, reset, Q);

always #5 clk = ~clk;

initial begin
    $dumpfile("out.vcd");
    $dumpvars(0, counter_testbench);

        clk = 0;
        reset = 1;
        #5 reset = 0;
        #65 reset = 1;
        #5 reset = 0;
        #100 $finish;
    end

    initial begin
        $monitor("time %0t, reset = %b, counter = %d", $time, reset, Q);
    end
endmodule 