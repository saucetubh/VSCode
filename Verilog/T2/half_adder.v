module half_adder (input a, input b, output sum, output cout);
    assign sum = a ^ b;  //a xor b
    assign cout = a & b;
//dont confuse bitwise operators and logical operators, in verilog we only use bitwise i.e | and &, not || or &&
endmodule
