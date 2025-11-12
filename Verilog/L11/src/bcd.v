module bcd(input [3:0]A, input [3:0]B, output [3:0]S, output T);
    wire [3:0]Z1;
    wire [3:0]Z2;
    wire c,k;
    fa4 fa41(A,B,1'b0,Z1,c);
    assign k = c|(Z1[3]&(Z1[2]|Z1[1]));
    assign Z2={1'b0,k,k,1'b0};
    fa4 fa42(Z1,Z2,1'b0,S,T);
endmodule

module fa(input a, b, cin, output s, cout);
    wire c1, c2, s1;
    ha h1(a,b,s1,c1);
    ha h2(s1,cin,s,c2);
    assign cout=c1|c2;
endmodule

module fa4(input [3:0]A, input [3:0]B, input cin, output [3:0]S, output cout);
    wire c1, c2, c3;
    fa f1(A[0], B[0], cin, S[0], c1);
    fa f2(A[1], B[1], c1, S[1], c2);
    fa f3(A[2], B[2], c2, S[2], c3);
    fa f4(A[3], B[3], c3, S[3], cout);
endmodule

module ha(input a, b, output s, cout);
    assign s=a^b;
    assign cout=a&b;
endmodule