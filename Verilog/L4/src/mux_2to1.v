module mux_2to1(
    output y,
    input in0, in1, sel
);
    wire nsel, w1, w2;
    not n1(nsel,sel);
    and a1(w1, nsel, in0);
    and a2(w2, sel, in1);
    or o1(y, w1, w2);  
endmodule