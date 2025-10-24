`include "up_counter.v"

module counter_tb;

    // Testbench signals
    reg clk;
    reg reset;
    wire [2:0] out;

    // Instantiate the counter
    up_counter uut (
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    // Clock generation: 10 ns period (100 MHz)
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize
        clk = 0;
        reset = 0;

        // Monitor signals
        $monitor("Time=%0t | reset=%b | out=%b", $time, reset, out);

        // Apply reset
        #5  reset = 1;
        #10 reset = 0;  // release reset

        // Let counter run for a while
        #100;

        // Assert reset again to test behavior mid-count
        #10 reset = 1;
        #10 reset = 0;

        // Run some more
        #80;

        // End simulation
        #10 $finish;
    end

endmodule
