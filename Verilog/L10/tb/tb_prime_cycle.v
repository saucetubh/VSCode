`include "src/prime_cycle.v"

module tb_prime_counter_struct;
    reg clk;
    reg reset;
    wire [3:0] q;
    wire [3:0] q_dec;
    
    assign q_dec = q; 
    prime_counter_struct dut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    always #5 clk = ~clk; 

    initial begin
        $dumpfile("public/vcd/tb_prime_counter_struct.vcd");
        $dumpvars(0, dut);

        clk = 0;
        reset = 0;

        $display("\nTesting prime_counter_struct\n");
        $display("|%-9s|%-5s|%-6s|%-14s|%-7s|",
                 "Time", "clk", "reset", "     q ", " q_dec");
        $display("|---------|-----|------|--------------|-------|");

        reset = 1; #10;

        $monitor("|%-9t|%-5b|%-6b|     %b%b%b%b     |  %2d   |",
                 $time, clk, reset, q[3], q[2], q[1], q[0], q_dec);
        reset = 0; #10;

        repeat (20) #10;

        $monitoroff;
        $finish;
    end
endmodule