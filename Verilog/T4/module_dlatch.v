module d_latch (input D,output reg Q,input enable);
    always @(D or enable) begin //or use allways @(*) since we want to monitor all inputs
        if (enable==1'b1) begin
            Q = D; //whenever enable is 1 Q will follow D
        end
    end
endmodule 