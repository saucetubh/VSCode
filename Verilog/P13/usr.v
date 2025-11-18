module usr(input clk, clr, msbin, lsbin, input [1:0]mode, input [3:0]D, input [3:0] initv, output reg [3:0]Q);
    always @(posedge clk or posedge clr) begin
        if(clr) Q<=initv;
        else begin
            case(mode)
                2'b01: Q <= {msbin, Q[3:1]}; //right shift
                2'b10: Q <= {Q[2:0], lsbin}; //left shift
                2'b11: Q <= D; //parallel load
                default: Q <= Q; //hold
            endcase
        end
    end
endmodule