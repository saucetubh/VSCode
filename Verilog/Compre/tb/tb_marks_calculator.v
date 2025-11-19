// tb_marks_calculator.v

`include "src/marks_calculator.v"

module tb_marks_calculator;
    reg clk = 0;
    reg reset;
    reg [3:0] submission;
    reg [3:0] key;
    wire [4:0] marks;

    marks_calculator DUT (
        .clk(clk),
        .reset(reset),
        .submission(submission),
        .key(key),
        .marks(marks)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("public/vcd/marks_calculator.vcd");
        $dumpvars(0, tb_marks_calculator);

        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|%-5s|",
                 "Time", "clk", "reset", "key", "sub", "marks");
        $display("|-----|-----|-----|-----|-----|-----|");

        reset = 1'b1; submission = 4'b0; key = 4'b1111; #10

        $monitor("|%-5d|%-5d|%-5b|%-5b|%-5b|%-5d|",
                 $time, clk, reset, key, submission, marks);
        reset = 1'b0;
        #10 key = 4'b0101; submission = 4'b0101; 
        #10 submission = 4'b0001; 
        #10 submission = 4'b0111;
        #10 key = 4'b1100; submission = 4'b0011;
        #10 submission = 4'b0111;
        #10 key = 4'b0100; submission = 4'b1101;
        #10 key = 4'b1111; submission = 4'b1001;
        #10 submission = 4'b0000;
        #10 key = 4'b0010; submission = 4'b0011;
        #10 submission = 4'b1010;
        #10 key = 4'b0110; submission = 4'b0100;
        #10 key = 4'b1000; submission = 4'b1110;
        #10 submission = 4'b0101;
        #10 reset = 1'b1;
        #10 reset = 1'b0; key = 4'b1001; submission = 4'b0110;
        #10 submission = 4'b0111;
        #10 submission = 4'b1001;
        #10 key = 4'b1100;
        #10 submission = 4'b1100;
        #10 submission = 4'b1100;
        #10 submission = 4'b1101;
        #10 key = 4'b0001; submission = 4'b0001;
        #10 reset = 1'b1;
        #10 reset = 1'b0; key = 4'b0; submission = 4'b0;


        #10 $finish;
    end






endmodule
