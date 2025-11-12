module register(input clk, clear, MSBin, LSBin, S1, S0, input [3:0]D, output reg [3:0]Q);
    always @(posedge clk or posedge clear) begin
        if(clear) Q<=4'b0000;
        else begin
            case({S1, S0})
                2'b01:begin
                    Q<={MSBin,Q[3],Q[2],Q[1]};
                end
                2'b10:begin
                    Q<={Q[2],Q[1],Q[0],LSBin};
                end
                2'b11:begin
                    Q<=D;
                end
            endcase
        end
    end
endmodule