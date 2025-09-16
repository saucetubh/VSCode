`include "src/half_adder.v"

module tb_half_adder;

    // Inputs
    reg a, b;

    // Outputs
    wire sum, cout;

    // Instantiate the half adder
    half_adder uut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(cout)
    );

    initial begin
        $dumpfile("public/vcd/wave_half_adder.vcd");
        $dumpvars(0, tb_half_adder);

        $display("\nTesting 1-bit Half Adder\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|", "Time", "a", "b", "sum", "cout");
        $display("|-----|-----|-----|-----|-----|");

        $monitor("|%-5d|%-5b|%-5b|%-5b|%-5b|", $time, a, b, sum, cout);

        // Apply test cases
            a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;

        #10 $finish;
    end

endmodule
