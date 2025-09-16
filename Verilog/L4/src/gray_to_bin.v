module gray_to_bin(
    output[2:0] binary,
    input[2:0] graycode
);
    buf b1(binary[2], graycode[2]);
    xor x1(binary[1], graycode[2], graycode[1]);
    xor x2(binary[0], binary[1], graycode[0]);
endmodule