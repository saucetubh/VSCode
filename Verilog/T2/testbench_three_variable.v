`include "three_variable.v" // file path to include

module testbench_three_variable();

reg a, b, c; // inputs as "reg" i.e registers 
wire out;    // outputs as "wire"

three_variable tv(a, b, c, out);  // called the function made in three_variable.v (the name of the module)
//tv is an instance name, can be anything, similar to how you were naming gates in gate-level modelling
initial begin
    $dumpfile("three_variable.vcd"); // create .vcd file
    $dumpvars(0, testbench_three_variable);  // dump the outputs given by file into signals which are read by gtkwave
    // we then open this in a waveform viewer called gtkwave

    // testcases
        a = 1'b0; b = 1'b0; c = 1'b1; // 1'b0 means 1 bit binary 0 and 1'b1 means 1 bit binary 1
    #10 a = 1'b1; b = 1'b1; c = 1'b1; //#10 is a delay operator, waits for 10 time units so that can usually see the output change
        a = 1'b0; b = 1'b1; c = 1'b0;
    #10 $finish;
end

initial begin
    $monitor("time = %0d, a = %b, b = %b, c = %b, out = %b", $time, a, b, c, out); //to get the output in our terminal
end
endmodule

