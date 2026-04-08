module D_ff(input clk, input chipSelect, input reset, input regWrite, input enable, input d, output reg q);
    always @ (posedge clk)
    begin
        if(chipSelect == 1'b1 && reset == 1'b1) 
        begin
            q <= 0; 
        end
        else if(regWrite == 1'b1 && enable == 1'b1 && chipSelect == 1'b1)   
        begin
            q <= d; 
        end
    end
endmodule