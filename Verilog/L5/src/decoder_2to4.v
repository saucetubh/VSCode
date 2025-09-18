module decoder_2to4(
    output [3:0] D,
    input [1:0] A,
    input E
);
    buf B1(D[3], A[1]&A[0]&E);
    buf B2(D[2], A[1]&(~A[0])&E);
    buf B3(D[1], (~A[1])&A[0]&E);
    buf B4(D[0], (~A[1])&(~A[0])&E);
endmodule