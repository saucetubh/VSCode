module decoder4to16(input [3:0] destReg, output reg [15:0] decOut);     // DONE
    always @ (destReg)
    begin
        case(destReg)
            4'd0:  decOut = 16'b0000_0000_0000_0001;
            4'd1:  decOut = 16'b0000_0000_0000_0010;
            4'd2:  decOut = 16'b0000_0000_0000_0100;
            4'd3:  decOut = 16'b0000_0000_0000_1000;
            4'd4:  decOut = 16'b0000_0000_0001_0000;
            4'd5:  decOut = 16'b0000_0000_0010_0000;
            4'd6:  decOut = 16'b0000_0000_0100_0000;
            4'd7:  decOut = 16'b0000_0000_1000_0000;
            4'd8:  decOut = 16'b0000_0001_0000_0000;
            4'd9:  decOut = 16'b0000_0010_0000_0000;
            4'd10: decOut = 16'b0000_0100_0000_0000;
            4'd11: decOut = 16'b0000_1000_0000_0000;
            4'd12: decOut = 16'b0001_0000_0000_0000;
            4'd13: decOut = 16'b0010_0000_0000_0000;
            4'd14: decOut = 16'b0100_0000_0000_0000;
            4'd15: decOut = 16'b1000_0000_0000_0000;
        endcase
    end
endmodule