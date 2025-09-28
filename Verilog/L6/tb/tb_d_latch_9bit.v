`include "src/d_latch_9bit.v"

module tb_d_latch_9bit;

    // Inputs
    reg  [8:0] D;
    reg        clk;
    reg        reset;
    reg        EN;

    // Output
    wire [8:0] Q;

    // DUT instantiation
    d_latch_9bit dut (
        .D(D),
        .clk(clk),
        .reset(reset),
        .EN(EN),
        .Q(Q)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("public/vcd/tb_d_latch_9bit.vcd");
        $dumpvars(0, tb_d_latch_9bit);
        
        $display("\nTesting d_latch_9bit\n");
        $display("|%-9s|%-9s|%-9s|%-9s|%-9s|%-15s|", 
                 "Time", "CLK", "D", "EN", "reset", "Q");
        $display("|---------|---------|---------|---------|---------|---------------|");
        $monitor("|%-9t|%-9b|%-9b|%-9b|%-9b|%-15b|", 
                 $time, clk, D, EN, reset, Q);

        D = 9'b0; EN = 0; reset = 0;

        #10 reset = 1;                          // Step 1: 
        #10 reset = 0;                          // Step 2: 
        #10 D = 9'b000000001; EN = 1;           // Step 3
        #10 D = 9'b000000010;                   // Step 4
        #10 EN = 0; D = 9'b000000011;           // Step 5 
        #10 D = 9'b000000100;                   // Step 6 
        #10 EN = 1; D = 9'b000001000;           // Step 7
        #10 D = 9'b000010000;                   // Step 8
        #10 reset = 1;                          // Step 9 
        #10 reset = 0; D = 9'b000100000; EN=1;  // Step 10
        #10 D = 9'b001000000;                   // Step 11
        #10 EN = 0; D = 9'b010000000;           // Step 12 
        #10 D = 9'b100000000;                   // Step 13 
        #10 EN = 1; D = 9'b111111111;           // Step 14
        #10 D = 9'b000000000;                   // Step 15 
        #10 D = 9'b101010101;                   // Step 16 
        #10 D = 9'b010101010;                   // Step 17
        #10 reset = 1;                          // Step 18
        #10 reset = 0; D = 9'b110110110; EN=1;  // Step 19
        #10 D = 9'b001001001;                   // Step 20

        $finish;
    end

endmodule
