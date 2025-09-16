module p_encoder(input [3:0]A, input E, output [1:0] O, output V);
    buf B1(O[1], E&(A[3]|A[2]));
    buf B2(O[0], E&(A[3]|((~A[2])&A[1])));
    buf B3(V, E&(A[3]|A[2]|A[1]|A[0]));
endmodule