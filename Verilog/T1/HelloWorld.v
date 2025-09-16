module HelloWorld(input a, input b, output o);

    wire w1, w2, w3, w4; //used to temporarily store output

    and g1(w1, a, b); // w1 -> output from the gate, a, b - inputs to the gate
    or g2(w2, a, b);
    xor g3(w3, a, b);
    not g4(w4, b);

    or g5(o, w1, w2, w3, w4);

endmodule

