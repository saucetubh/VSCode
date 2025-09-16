`include "src/full_adder.v"

module tb_full_adder;

    // Inputs
    reg a, b, cin;

    // Outputs
    wire sum, cout;

    // Instantiate the full adder
    full_adder uut (
        .a(a),
        .b(b),
        .carry_in(cin),
        .sum(sum),
        .carry_out(cout)
    );

    initial begin
        $dumpfile("public/vcd/wave_full_adder.vcd");
        $dumpvars(0, tb_full_adder);

        $display("\nTesting 1-bit Full Adder\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|%-5s|", "Time", "a", "b", "cin", "sum", "cout");
        $display("|-----|-----|-----|-----|-----|-----|");
        $monitor("|%-5d|%-5b|%-5b|%-5b|%-5b|%-5b|", $time, a, b, cin, sum, cout);

        // Apply test cases
            a = 0; b = 0; cin = 0;
        #10 a = 0; b = 0; cin = 1;
        #10 a = 0; b = 1; cin = 0;
        #10 a = 0; b = 1; cin = 1;
        #10 a = 1; b = 0; cin = 0;
        #10 a = 1; b = 0; cin = 1;
        #10 a = 1; b = 1; cin = 0;
        #10 a = 1; b = 1; cin = 1;

        #10 $finish;
    end

endmodule
