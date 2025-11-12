`include "Q6_part2_sync.v"
module upcounter_testbench();
reg clk, reset;
wire [2:0] counter;

up_counter dut(clk, reset, counter);

always #5 clk = ~clk;

initial begin
    $dumpfile("out.vcd");
    $dumpvars(0, upcounter_testbench);

        clk = 0;
        reset = 1;
        #5 reset = 0;
        #45 reset = 1;
        #5 reset = 0;
        #400 $finish;
    end

    initial begin
        $monitor("At time %0t, reset = %b, counter = %d", $time, reset, counter);
    end
endmodule 