module bin_to_gray(
    output[3:0] graycode,
    input[3:0] binary
);
    buf b1(graycode[3], binary[3]);
    xor x1(graycode[2], binary[3], binary[2]);
    xor x2(graycode[1], binary[2], binary[1]);
    xor x3(graycode[0], binary[1], binary[0]);
    
endmodule