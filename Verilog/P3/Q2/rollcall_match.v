// include decoder and encoder here, if you plan to use them
// see tb_rollcall.v for expected behavior
`include "decoder_2to4.v"
`include "encoder_4to2.v"
module rollcall(
    input [1:0] S0, input [1:0] S1, input [1:0] S2, input [1:0] S3, 
    input [1:0] PAT,
    input MODE, 
    output [3:0] MATCH,
    output ANY,
    output PAR,
    output [1:0] FIRST,
    output [1:0] Y
);
    wire [3:0] P1, P2, P3, P4, Con; //storing pairs 
    //buf B1(P1, {S0, S1}); does not work, buf is primitive and expects single bit inputs/outputs
    buf B1_0(P1[3], S0[1]); 
    buf B1_1(P1[2], S0[0]);
    buf B1_2(P1[1], S1[1]);
    buf B1_3(P1[0], S1[0]); 
    buf B2_0(P2[3], S1[1]);
    buf B2_1(P2[2], S1[0]);
    buf B2_2(P2[1], S2[1]);
    buf B2_3(P2[0], S2[0]);
    buf B3_0(P3[3], S2[1]);
    buf B3_1(P3[2], S2[0]);
    buf B3_2(P3[1], S3[1]);
    buf B3_3(P3[0], S3[0]);
    buf B4_0(P4[3], S3[1]);
    buf B4_1(P4[2], S3[0]);
    buf B4_2(P4[1], S0[1]);
    buf B4_3(P4[0], S0[0]);
    buf B5_0(Con[3], PAT[1]);
    buf B5_1(Con[2], PAT[0]);
    buf B5_2(Con[1], (!PAT[1]&!PAT[0]&MODE)|(!PAT[1]&PAT[0]&!MODE)|(PAT[1]&!PAT[0]&!MODE)|(PAT[1]&PAT[0]&MODE));
    buf B5_3(Con[0], !PAT[0]);      
    //buf B5(Con, {PAT, (!PAT[1]&!PAT[0]&MODE)|(!PAT[1]&PAT[0]&!MODE)|(PAT[1]&!PAT[0]&!MODE)|(PAT[1]&PAT[0]&MODE), !PAT[0]}); wont work for the same reason as earlier
    isequal IE1(P1, Con, MATCH[0]);
    isequal IE2(P2, Con, MATCH[1]);
    isequal IE3(P3, Con, MATCH[2]);
    isequal IE4(P4, Con, MATCH[3]);

    buf B6(ANY, (MATCH[0] | MATCH[1] | MATCH[2] | MATCH[3]));
    buf B7(PAR, (MATCH[0] ^ MATCH[1] ^ MATCH[2] ^ MATCH[3])); //in this specific case, simply do buf B7(PAR, ANY);

    encoder_4to2 ENC1(MATCH, ANY, FIRST);

    buf B8(Y[1], ANY&Con[1]);
    buf B9(Y[0], ANY&Con[0]);    
    /*
    wire [3:0] dS0, dS1, dS2, dS3, dPAT;
    decoder_2to4 DEC0(S0, 1'b1, dS0);
    decoder_2to4 DEC1(S1, 1'b1, dS1);
    decoder_2to4 DEC2(S2, 1'b1, dS2);
    decoder_2to4 DEC3(S3, 1'b1, dS3);
    decoder_2to4 DECP(PAT, 1'b1, dPAT);
    */
endmodule


//creating module for equality check
module isequal(input[3:0] A, input [3:0] B, output O);
    buf BE(O, ((A[3] ~^ B[3]) & (A[2] ~^ B[2]) & (A[1] ~^ B[1]) & (A[0] ~^ B[0])));
endmodule