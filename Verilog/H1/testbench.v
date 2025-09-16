`include "Q1.v"

module tb_func;

reg a,b,c,d;
wire o;
integer i;
func f(a, b, c, d, o);

initial begin
    $dumpfile("tb_func.vcd");
    $dumpvars(0, tb_func);
end

initial begin
    for (i = 0; i < 16; i = i + 1) begin
        {a, b, c, d} = i;
        #10;
    end
    $finish;
end

initial $monitor("Time = %0d, a = %b, b = %b, c = %b, d = %b, o = %b", $time, a, b, c, d, o);

endmodule