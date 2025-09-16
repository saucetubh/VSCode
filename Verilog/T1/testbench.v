`include "HelloWorld.v"

module tb_HelloWorld;

reg a, b;
wire o;

HelloWorld h1(a, b, o);

initial begin
    $dumpfile("tb_HelloWorld.vcd");
    $dumpvars(0, tb_HelloWorld);

    a = 1'b0; b = 1'b0;
    #10 a = 1'b0; b = 1'b1;
    #10 $finish;
end

initial $monitor("a = %b, b = %b, o = %b", a, b, o);

endmodule
