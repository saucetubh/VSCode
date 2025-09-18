module priority_encoder_4to2(
    output [1:0] Y,
    output V,
    input [3:0] I,
    input E
);
    buf B1(Y[1], (I[3]|I[2])&E);
    buf B2(Y[0], ((I[3]|(~I[2])&I[1])&E));
    buf B3(V, E&(I[3]|I[2]|I[1]|I[0]));
endmodule