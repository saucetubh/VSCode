module decoder_2to4(input [1:0] A, input E, output [3:0] O);
    buf B1(O[0], E&(!A[1])&(!A[0]));
    buf B2(O[1], E&(!A[1])&(A[0]));
    buf B3(O[2], E&(A[1])&(!A[0]));
    buf B4(O[3], E&(A[1])&(A[0]));
endmodule

//or simply do `include "Q1/decoder_2to4.v" and then instantiate the module