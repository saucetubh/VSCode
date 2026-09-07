//IF select is 0 then muxout is in0. IF select is 1 then muxout is in1.

module mux2to1_16bits(input [15:0] in0, input [15:0] in1, input select, output reg [15:0] muxOut);
    always @(*) begin
        if(select) begin
            muxOut = in1;
        end
        else begin
            muxOut = in0;
        end
    end
endmodule