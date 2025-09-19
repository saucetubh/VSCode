module sr_latch(input R,input S,input enable,output reg  Q,output reg  Q_n); //if you see reg without output it hints that you have to use behavioural modeling
    /*
        always @(*) begin
        if (enable == 1'b1) begin
            case({S,R}) //concat used 
            2'b00: begin //for this value i.e R=0 and S=0
                Q=Q;
                Q_n=Q_n; 
            end //dont have to write this since no change
            2'b01: begin
                Q=1'b0;
                Q_n=1'b1;
            end
            2'b10: begin
                Q=1'b1;
                Q_n=1'b0;
            end
            endcase //no need to give default case
        end
    end //if you start your testbench with such a case where latch is in memory state i.e outputs Q and Q_n, then the outputs will be x and x since they are not yet initialized
    */ 
    always @(S or R or enable) begin //since al inputs are inside we can write always @(*)
        if (enable==1'b1) begin
            if (S == 1'b0 && R == 1'b0) begin
                Q = Q;
                Q_n = Q_n;
            end //we dont really need to write this since no changes happen here
            else if (S == 1'b1 && R == 1'b0) begin
                Q = 1'b1;
                Q_n = 1'b0;
            end
            else if (S == 1'b0 && R == 1'b1) begin
                Q = 1'b0;
                Q_n = 1'b1;
            end
        end //we dont really need to write for enable 0 since no changes happen there
    end //we dont really need to write for S=1 and R=1 since its invalid/indeterminate state, ambiguous since Q might reach first and give some value or Q_n might reach first and give some value
endmodule

//difference between wire and reg is that wire is used for continuous assignment and reg is used for procedural assignment

//value of outputs will depend on your order of inputs in testbench