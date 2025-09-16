module halfAdder_1bit(input A, input B, output Sum, output Carry);
    // WRITE YOUR CODE HERE
    //assign Sum = A ^ B;
    //assign Carry = A & B;
    xor x1(Sum, A, B);
    and a1(Carry, A, B);
endmodule

// Both A and B are 1 bit inputs
// Try to solve with Dataflow Modelling
