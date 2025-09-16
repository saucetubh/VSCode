`include "func.v"

module pass(input[7:0] in, output[3:0] out);

    wire w1;
    assign w1 = in[5];
    // func f1(in[5:2], out); // slicing -> passing larger to smaller
    // func f1({w1, in[4:2]}, out); // concatenation
    // func f1({1'b0, in[4:2]}, out);
    
endmodule