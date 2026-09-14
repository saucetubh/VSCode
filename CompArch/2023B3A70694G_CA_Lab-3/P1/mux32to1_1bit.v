/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

module Mux2to1_1bit(input in0, input in1, input sel, output out);
    wire y1, y2, notsel;
    
    not (notsel, sel);

    and (y1, in0, notsel);
    and (y2, in1, sel);
    or (out, y1, y2);
endmodule

module Mux4to1_1bit(input in0, input in1, input in2, input in3, input[1:0] sel, output out);

    wire y100, y200;

    Mux2to1_1bit m211b1(in0, in1, sel[0], y1);
    Mux2to1_1bit m211b2(in2, in3, sel[0], y2);
    Mux2to1_1bit m211b3(y1, y2, sel[1], out);
endmodule

module Mux8to1_1bit(input in0, input in1, input in2, input in3, input in4, input in5, input in6, input in7, input[2:0] sel, output out);

    wire y3, y4;

    Mux4to1_1bit m411b1(in0, in1, in2, in3, sel[1:0], y3);
    Mux4to1_1bit m411b2(in4, in5, in6, in7, sel[1:0], y4);
    Mux2to1_1bit m211b4(y3, y4, sel[2], out);
endmodule

module Mux16to1_1bit(input in0, input in1, input in2, input in3, input in4, input in5, input in6, input in7, input in8, input in9, input in10,
                        input in11, input in12, input in13, input in14, input in15, input[3:0] sel, output out);

    wire y5, y6;

    Mux8to1_1bit m811b1(in0, in1, in2, in3, in4, in5, in6, in7, sel[2:0], y5);
    Mux8to1_1bit m811b2(in8, in9, in10, in11, in12, in13, in14, in15, sel[2:0], y6);
    Mux2to1_1bit m211b5(y5, y6, sel[3], out);
endmodule


module Mux32to1_1bit(input in0,input in1,input in2,input in3,input in4,input in5,input in6,input in7,input in8,input in9,input in10,input in11,input in12,
                        input in13,input in14,input in15,input in16,input in17,input in18,input in19,input in20,input in21,input in22,input in23,input in24,
                        input in25,input in26,input in27,input in28,input in29,input in30,input in31,input[4:0] select,output out);

    wire s0_bar,s1_bar,s2_bar,s3_bar,s4_bar;
    wire and_op0,and_op1,and_op2,and_op3,and_op4,and_op5,and_op6,and_op7,and_op8,and_op9,and_op10,and_op11,and_op12,and_op13,and_op14,
    and_op15,and_op16,and_op17,and_op18,and_op19,and_op20,and_op21,and_op22,and_op23,and_op24,and_op25,and_op26,and_op27,and_op28,and_op29,
    and_op30,and_op31;

    wire y7, y8;
    Mux16to1_1bit m1611b1(in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, select[3:0], y7);
    Mux16to1_1bit m1611b2(in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, select[3:0], y8);
    Mux2to1_1bit m211b6(y7, y8, select[4], out);

endmodule