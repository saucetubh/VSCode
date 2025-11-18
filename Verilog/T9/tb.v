// tb_top_module.v
`include "q4.v"

module tb_top_module();

    reg clk;
    reg rst;
    reg ctrl;
    reg [3:0] num1;
    reg [3:0] num2;
    wire [3:0] out1;
    wire [3:0] out2;
    wire sum;

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .rst(rst),
        .ctrl(ctrl),
        .num1(num1),
        .num2(num2),
        .out1(out1),
        .out2(out2),
        .sum(sum)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor statement to print values in the terminal
    initial begin
        $monitor("Time: %0t | clk: %b | rst: %b | ctrl: %b | num1: %b | num2: %b | out1: %b | out2: %b | C = %b | sum: %b",
                 $time, clk, rst, ctrl, num1, num2, out1, out2, uut.Cout, sum);
    end

    // Test sequence
    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_top_module);

        // Initialize inputs
        ctrl = 1; 
        num1 = 4'b1010; 
        num2 = 4'b1110; 
        rst = 1;
        #5 rst = 0;
        #20 ctrl = 0;
        #20 ctrl = 1;
        // Wait for a few clock cycles
        #30 $finish;
    end

endmodule
