`include "src/magic_adder.v"

module tb_magic_adder;

    reg  [2:0] a, b;
    reg        is_gray;
    wire [3:0] sum;

    // Instantiate DUT
    magic_adder uut (
        .sum(sum),
        .a(a),
        .b(b),
        .is_gray(is_gray)
    );

    initial begin
        $dumpfile("public/vcd/wave_magic_adder.vcd");
        $dumpvars(0, tb_magic_adder);

        $display("\nTesting Magic Adder\n");
        $display("|%-5s|%-5s|%-5s|%-7s|%-5s|",
                 "Time","a","b","is_gray","sum");
        $display("|-----|-----|-----|-------|-----|");
        $monitor("|%-5d|%-5b|%-5b|%-7b|%-5b|",
                 $time, a, b, is_gray, sum);

            a=3'b001; b=3'b010; is_gray=0;
        #10 a=3'b101; b=3'b011; is_gray=1;
        #10 a=3'b111; b=3'b001; is_gray=0;
        #10 a=3'b100; b=3'b011; is_gray=1;
        #10 a=3'b011; b=3'b110; is_gray=1;
        #10 a=3'b010; b=3'b010; is_gray=0;
        #10 a=3'b111; b=3'b111; is_gray=0;
        #10 a=3'b000; b=3'b111; is_gray=1;
        #10 a=3'b110; b=3'b001; is_gray=1;
        #10 a=3'b111; b=3'b000; is_gray=1;
        #10 a=3'b101; b=3'b010; is_gray=0;
        #10 a=3'b100; b=3'b011; is_gray=0;
        
        // FILL THE 4 TESTCASES BELOW FROM THE TABLE IN THE LABSHEET

        #10 a=3'b001; b=3'b101; is_gray=0;
        #10 a=3'b010; b=3'b111; is_gray=1;
        #10 a=3'b011; b=3'b100; is_gray=0;
        #10 a=3'b111; b=3'b111; is_gray=1;

        // -----------------------------------------------------

        #10 $finish;
    end

endmodule
