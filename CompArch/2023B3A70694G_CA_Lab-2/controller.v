module controller(input reset, input stop, input min_lesser_than, input max_greater_than, output reg memWrite, output reg loadPc, output reg loadMin, output reg loadMax, output reg loadLimit, output reg pcUpdate, output reg minUpdate, output reg maxUpdate, output reg limitUpdate);
    always @(*) begin
        memWrite = 1'b0; //doesn't matter since memory is hardcoded when reset is high, after which the memory is read only
        if (reset) begin
            loadPc = 1'b1;
            loadMin = 1'b1;
            loadMax = 1'b1;
            loadLimit = 1'b1;
            pcUpdate = 1'b1; 
            minUpdate = 1'b1;
            maxUpdate = 1'b1;
            limitUpdate = 1'b1;
        end
        //this sets pc = 0, minData = FFFF, maxData = 0000, limitValue = 10 at reset
        else begin
            loadLimit = 1'b0;
            loadPc = 1'b0;
        end
        if (stop) begin
            pcUpdate = 1'b0;
            limitUpdate = 1'b0;
        end
        if (min_lesser_than) begin
            loadMin = 1'b0;
        end
        if (max_greater_than) begin
            loadMax = 1'b0;
        end
        minUpdate = min_lesser_than;
        maxUpdate = max_greater_than;
    end
endmodule
