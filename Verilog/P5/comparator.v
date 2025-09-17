module isequal_1bit(input A, input B, output O); 
    buf B1(O, (A ~^ B));
endmodule
module isequal_4bit(input[3:0]A, input [3:0]B, output O); //outputs 1 if A and B are equal
    wire O0, O1, O2, O3;
    isequal_1bit IE11(A[0], B[0], O0);
    isequal_1bit IE12(A[1], B[1], O1);
    isequal_1bit IE13(A[2], B[2], O2);
    isequal_1bit IE14(A[3], B[3], O3);
    and A1(O, O0, O1, O2, O3);
endmodule

module isgreater(input[3:0]A, input [3:0]B, output O); //outputs 1 if A > B
    wire w3, w2, w1, w0;
    wire x3, x2, x1;
    isequal_1bit IE13(A[3], B[3], x3);
    isequal_1bit IE12(A[2], B[2], x2);
    isequal_1bit IE11(A[1], B[1], x1);
    buf B1(w3, A[3]&(~B[3]));
    buf B2(w2, A[2]&(~B[2])&x3);
    buf B3(w1, A[1]&(~B[1])&x3&x2);
    buf B4(w0, A[0]&(~B[0])&x3&x2&x1);
    or o1(O, w3, w2, w1, w0);
    //logic behind this is leftmost bit (MSB) of A is 1 and B is 0
    //or if MSB of both are equal then the next bit of A is 1 and B is 0 and so on
endmodule //this module outputs 0 if they are equal or lesser

module islesser(input[3:0]A, input [3:0]B, output O); //outputs 1 if A < B
    wire O1, O2;
    isequal_4bit IE41(A, B, O1);
    isgreater IG1(A, B, O2);//i cant directly negate this since O2 would be 0 even when A and B are equal
    buf B1(O, O1 ~^ O2); //this expression was obtained by making truth table of O1, O2 and O
endmodule 
