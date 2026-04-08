//selects 2 bytes of a memory corresponding to the select input
module mux32to2(input [7 : 0] in0,   input [7:0] in1,   input [7:0] in2,   input [7:0] in3, input [7:0] in4, input [7:0] in5,   input [7:0] in6,   input [7:0] in7, input [7:0] in8,   input [7:0] in9,   input [7:0] in10,  input [7:0] in11, input [7:0] in12,  input [7:0] in13,  input [7:0] in14,  input [7:0] in15, input [7:0] in16,  input [7:0] in17,  input [7:0] in18,  input [7:0] in19, input [7:0] in20,  input [7:0] in21,  input [7:0] in22,  input [7:0] in23, input [7:0] in24,  input [7:0] in25,  input [7:0] in26,  input [7:0] in27, input [7:0] in28,  input [7:0] in29,  input [7:0] in30,  input [7:0] in31, input [3:0] select, output reg [15:0] muxOut);
    always @ (in0,   in1,   in2,   in3,   in4,   in5,   in6,   in7, 
            in8,   in9,   in10,  in11,  in12,  in13,  in14,  in15,   
            in16,  in17,  in18,  in19,  in20,  in21,  in22,  in23, 
            in24,  in25,  in26,  in27,  in28,  in29,  in30,  in31,
            select)
	begin
        case(select)
            5'd0:  muxOut = {in0,   in1};
            5'd1:  muxOut = {in2,   in3};
            5'd2:  muxOut = {in4,   in5};
            5'd3:  muxOut = {in6,   in7};
            5'd4:  muxOut = {in8,   in9};
            5'd5:  muxOut = {in10,   in11};
            5'd6:  muxOut = {in12,   in13};
            5'd7:  muxOut = {in14,   in15};
            5'd8:  muxOut = {in16,   in17};
            5'd9:  muxOut = {in18,   in19};
            5'd10: muxOut = {in20,   in21};
            5'd11: muxOut = {in22,   in23};
            5'd12: muxOut = {in24,   in25};
            5'd13: muxOut = {in26,   in27};
            5'd14: muxOut = {in28,   in29};
            5'd15: muxOut = {in30,   in31};
        endcase
    end
endmodule