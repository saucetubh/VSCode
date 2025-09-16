`include "PrimeNumbers.v"

module testbench;
reg a, b, c, d, e;
wire o;

primes h1(a, b, c, d, e, o);
wire [4:0] num = {a, b, c, d, e};

initial begin
    $dumpfile("tb_PrimeNumbers.vcd");
    $dumpvars(0, testbench);

    a = 0; b = 0; c = 0; d = 0; e = 0;
    #10 a = 0; b = 0; c = 0; d = 0; e = 1;
    #10 a = 0; b = 0; c = 0; d = 1; e = 0;
    #10 a = 0; b = 0; c = 0; d = 1; e = 1;
    #10 a = 0; b = 0; c = 1; d = 0; e = 0;
    #10 a = 0; b = 0; c = 1; d = 0; e = 1;
    #10 a = 0; b = 0; c = 1; d = 1; e = 0;
    #10 a = 0; b = 0; c = 1; d = 1; e = 1;
    #10 a = 0; b = 1; c = 0; d = 0; e = 0;
    #10 a = 0; b = 1; c = 0; d = 0; e = 1;
    #10 a = 0; b = 1; c = 0; d = 1; e = 0;
    #10 a = 0; b = 1; c = 0; d = 1; e = 1;
    #10 a = 0; b = 1; c = 1; d = 0; e = 0;
    #10 a = 0; b = 1; c = 1; d = 0; e = 1;
    #10 a = 0; b = 1; c = 1; d = 1; e = 0;
    #10 a = 0; b = 1; c = 1; d = 1; e = 1;
    #10 a = 1; b = 0; c = 0; d = 0; e = 0;
    #10 a = 1; b = 0; c = 0; d = 0; e = 1;
    #10 a = 1; b = 0; c = 0; d = 1; e = 0;
    #10 a = 1; b = 0; c = 0; d = 1; e = 1;
    #10 a = 1; b = 0; c = 1; d = 0; e = 0;
    #10 a = 1; b = 0; c = 1; d = 0; e = 1;
    #10 a = 1; b = 0; c = 1; d = 1; e = 0;
    #10 a = 1; b = 0; c = 1; d = 1; e = 1;
    #10 a = 1; b = 1; c = 0; d = 0; e = 0;
    #10 a = 1; b = 1; c = 0; d = 0; e = 1;
    #10 a = 1; b = 1; c = 0; d = 1; e = 0;
    #10 a = 1; b = 1; c = 0; d = 1; e = 1;
    #10 a = 1; b = 1; c = 1; d = 0; e = 0;
    #10 a = 1; b = 1; c = 1; d = 0; e = 1;
    #10 a = 1; b = 1; c = 1; d = 1; e = 0;
    #10 a = 1; b = 1; c = 1; d = 1; e = 1;
    #20 $finish;

end

initial $monitor("Time = %0d, Number = %0d, Is_Prime = %b", $time, num, o); //$monitor is the print function for iverilog

endmodule

