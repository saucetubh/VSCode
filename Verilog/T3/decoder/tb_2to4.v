`include "decoder_2to4.v"
module tb_decoder;
reg [1:0] in;
wire [3:0] out;
decoder_2to4 D1(in, out);
initial begin
    $dumpfile("tb_decoder.vcd");
    $dumpvars(0, tb_decoder);
    in = 2'b00;
    #10 in = 2'b01;
    #10 in = 2'b10;
    #10 in = 2'b11;
    #10 $finish;
end
initial begin
    $monitor("time=%0d, A=%b, D=%b", $time, in, out);
end
endmodule

//cursor trick - shift+Option to extend cursor vertically

