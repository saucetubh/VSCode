module half_adder(
    output sum, carry,
    input a, b
);
    xor x1(sum, a, b);
    and a1(carry, a, b);

endmodule