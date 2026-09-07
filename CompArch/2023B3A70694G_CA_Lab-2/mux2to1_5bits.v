//IF select is 0 then muxout is in0. IF select is 1 then muxout is in1.

module mux2to1_5bits(input [4:0] in0, input [4:0] in1, input select, output reg [4:0] muxOut);
    always @(*) begin
        if (select) begin
            muxOut = in1; //blocking assignment since it is a combinational circuit
        end 
        else begin
            muxOut = in0;
        end
    end
endmodule