// include decoder and encoder modules if you wish to use them
// prefix the included module names with "src/"
`include "decoder_2to4.v"
`include "priority_encoder_4to2.v"
module podium_permutations(
    output VALID,
    output POI,
    output [7:0] IMAP,
    input [1:0] N0,
    input [1:0] N1,
    input [1:0] N2,
    input [1:0] N3
);
    wire t1, t2, t3, t4, t5, t6;
    isequal ie1(N0, N1, t1);
    isequal ie2(N0, N2, t2);
    isequal ie3(N0, N3, t3);
    isequal ie5(N1, N2, t4);
    isequal ie6(N1, N3, t5);
    isequal ie8(N2, N3, t6); 
    buf B0(VALID, ~(t1|t2|t3|t4|t5|t6));

    wire [3:0] w3, w2, w1, w0;

    decoder_2to4 DE3(w3, N3, 1'b1);
    decoder_2to4 DE2(w2, N2, 1'b1);
    decoder_2to4 DE1(w1, N1, 1'b1);
    decoder_2to4 DE0(w0, N0, 1'b1);

    wire V3, V2, V1, V0;

    priority_encoder_4to2 PE3({IMAP[7], IMAP[6]}, V3, {w3[3], w2[3], w1[3], w0[3]}, 1'b1);
    priority_encoder_4to2 PE2({IMAP[5], IMAP[4]}, V2, {w3[2], w2[2], w1[2], w0[2]}, 1'b1);
    priority_encoder_4to2 PE1({IMAP[3], IMAP[2]}, V1, {w3[1], w2[1], w1[1], w0[1]}, 1'b1);
    priority_encoder_4to2 PE0({IMAP[1], IMAP[0]}, V0, {w3[0], w2[0], w1[0], w0[0]}, 1'b1);

    buf B1(POI, VALID&((w3[3]&!w2[2]&!w1[1]&!w0[0])|(!w3[3]&w2[2]&!w1[1]&!w0[0])|(!w3[3]&!w2[2]&w1[1]&!w0[0])|(!w3[3]&!w2[2]&!w1[1]&w0[0])));

endmodule

module isequal(input [1:0]A, input [1:0]B, output Y);
    buf B1(Y, ((A[1]^~B[1])&(A[0]^~B[0])));
endmodule
