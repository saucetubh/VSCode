// tb_shift_right_register.v

`include "src/shift_right_register.v"

module tb_shift_right_register;

    reg clk = 0;
    reg reset;
    reg hold;
    reg [3:0] shift_in;
    reg [31:0] init_val;
    wire [31:0] data;
    wire [3:0] shift_out;

    shift_right_register DUT (
        .clk(clk),
        .reset(reset),
        .hold(hold),
        .shift_in(shift_in),
        .init_val(init_val),
        .data(data),
        .shift_out(shift_out)
    );

    always #5 clk = ~clk;   // 10ns period

    initial begin
        $dumpfile("public/vcd/shift_right_register.vcd");
        $dumpvars(0, tb_shift_right_register);

        // start with a reset
        reset = 1'b1; hold = 1'b0; init_val = 32'hA5A5_F0F0; shift_in = 4'h0;
        #10 reset = 1'b0;

        #5 shift_in = 4'h3;
        #10 shift_in = 4'hF;

        #10 hold = 1'b1; // hold active (no shifting)
        #10 shift_in = 4'h6;

        #10 hold = 1'b0; shift_in = 4'h9;
        #10 shift_in = 4'h1;

        // change init_val and reset again
        #10 reset = 1'b1; init_val = 32'hDEAD_BEEF;
        #10 reset = 1'b0; shift_in = 4'hA;

        #10 shift_in = 4'hC;
        #10 shift_in = 4'h5;
        #10 hold = 1'b1;
        #10 hold = 1'b0; shift_in = 4'h7;

        // another reset burst
        #10 reset = 1'b1;
        #10 reset = 1'b0; init_val = 32'h1234_ABCD; shift_in = 4'h4;

        #10 shift_in = 4'h2;
        #10 shift_in = 4'hE;
        #10 hold = 1'b1;
        #10 hold = 1'b0; shift_in = 4'h8;

        #10 $finish;
    end

    initial begin
        $display("|%-5s|%-5s|%-5s|%-5s|%-10s|%-10s|%-6s|",
                 "Time", "clk", "rst", "hold", "shift_in", "data", "out");
        $display("|-----|-----|-----|-----|----------|----------|------|");
        $monitor("|%-5d|%-5b|%-5b|%-5b|0x%-8h|0x%-8h|0x%-4h|",
                 $time, clk, reset, hold, shift_in, data, shift_out);
    end

endmodule
