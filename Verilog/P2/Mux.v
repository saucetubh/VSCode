//objective - output A if s=1, output B if s=0
//multiple bit mux
//diagramatically this can be represented as either a 8x4 mux, with 3 select lines or 4 2x1 muxes with 1 select line
module mux(input [3:0]A, input [3:0]B, input s, output[3:0]Y);
    //assign Y = ((s&A) | ((!s)&B)); //this is incorrect, s is 1bit but A and B are 4bits. Need to do this individually for each bit
    assign Y[0] = ((s&A[0]) | ((!s)&B[0]));
    assign Y[1] = ((s&A[1]) | ((!s)&B[1]));
    assign Y[2] = ((s&A[2]) | ((!s)&B[2]));
    assign Y[3] = ((s&A[3]) | ((!s)&B[3]));
    //assign Y = (s) ? A : B; much simpler
endmodule
