`include "mux_design.v"

module tb_mux_design;

reg A, B, C;
wire Z2;

mux_design md(A, B, C, Z2);

initial begin
    $dumpfile("tb_mux_design.vcd");
    $dumpvars(0, tb_mux_design);

    A = 1'b0; B = 1'b0; C = 1'b0;
    #10 A = 1'b0; B = 1'b0; C = 1'b1;
    #10 A = 1'b0; B = 1'b1; C = 1'b0;
    #10 A = 1'b0; B = 1'b1; C = 1'b1;
    #10 A = 1'b1; B = 1'b0; C = 1'b0;
    #10 A = 1'b1; B = 1'b0; C = 1'b1;
    #10 A = 1'b1; B = 1'b1; C = 1'b0;
    #10 A = 1'b1; B = 1'b1; C = 1'b1;
    #10 $finish;
end

initial begin
    $monitor("time = %0d, A = %b, B = %b, C = %b, Z2 = %b", $time, A, B, C, Z2);
end

endmodule
