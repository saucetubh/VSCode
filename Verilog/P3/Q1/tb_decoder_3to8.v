`include "decoder_3to8.v"

module tb_decoder_3to8;

reg [2:0] A;
reg E;
wire [7:0] O;

decoder_3to8 dec(A, E, O);

initial begin
    $dumpfile("tb_decoder_3to8.vcd");
    $dumpvars(0, tb_decoder_3to8);
    A = 3'b000; E = 1'b0;
    #10 A = 3'b000;E = 1'b1;
    #10 A = 3'b001;E = 1'b1;
    #10 A = 3'b010;E = 1'b1;
    #10 A = 3'b011;E = 1'b0;
    #10 A = 3'b011;E = 1'b1;
    #10 A = 3'b100;E = 1'b1;
    #10 A = 3'b101;E = 1'b1;
    #10 A = 3'b110;E = 1'b1;
    #10 A = 3'b111;E = 1'b1;
    #10 $finish;
end

initial begin
    $monitor("time = %0d, A = %b, E = %b, O = %b", $time, A, E, O);
end

endmodule
