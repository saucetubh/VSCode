`include "half_adder.v" 

module testbench_half_adder();
    reg a, b;
    wire sum, cout;

    half_adder ha(a, b, sum, cout);

    initial begin
        $dumpfile("testbench_half_adder.vcd");
        $dumpvars(0, testbench_half_adder);

        a=1'b0; b=1'b1;
    #10 a=1'b1; b=1'b1;
    #10 $finish;
    end

    initial begin 
        $monitor("time = %0d, a = %b, b = %b, sum = %b, cout = %b", $time, a, b, sum, cout);
    end
endmodule