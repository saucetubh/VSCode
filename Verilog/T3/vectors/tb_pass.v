`include "pass.v"

module tb_pass;
reg [7:0] in;
wire [3:0] out;

pass p(in, out);

initial begin
    $dumpfile("tb_pass.vcd");
    $dumpvars(0, tb_pass);
    
    in = 8'b00000000;
    #10 in = 8'b11111111;
    #10 in = 8'b10101010;
    #10 in = 8'b01010101;
    #10 $finish;
end

initial begin
    $monitor("in = %b, out = %b", in, out);
end

endmodule
