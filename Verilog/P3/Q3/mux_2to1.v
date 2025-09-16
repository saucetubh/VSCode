module mux_2to1(input [1:0] A, input S, output O);
    buf B1(O, ((!S)&A[0])|(S&A[1])); //outputs A[1] if S is 1 and A[0] if S is 0
endmodule