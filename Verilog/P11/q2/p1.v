module p1(input [3:0]X, output [3:0]Y);
  assign Y = {X[3]|(X[2]&X[0])|(X[2]&X[1]), X[2]^(X[0]|X[1]), (X[1]^Y[0]), ~X[0]}; //using Y[0] works since continuous assignment
endmodule

//can you think of other unique ways to implement this