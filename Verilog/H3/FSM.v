module FSMQ2(input clk, input reset, input in, output reg out);
    reg[1:0] state, nextstate; //since f.state used in testbench, meaning the variable name should be state
    parameter[1:0] A=2'b00, B=2'b01, C=2'b10, D=2'b11; //use same parameters as used in testbench
    always @(posedge clk or posedge reset) begin //from expected output png we know reset is active high asynchronous
        if(reset) begin
            state <= A;
        end
        else begin
            state <= nextstate;
        end
    end
    always @(*) begin
        case (state)
        A: begin
            out = 0;  //since moore machine, output depends only on state, not input
            if(in) nextstate = B;
            else if(~in) nextstate = A;
        end
        B: begin
            out = 0;
            if(in) nextstate = B;
            else if(~in) nextstate = C;
        end
        C: begin
            out = 0;
            if(in) nextstate = D;
            else if(~in) nextstate = A;
        end
        D: begin
            out = 1;
            if(in) nextstate = B;
            else if(~in) nextstate = C;
        end
        endcase
    end
endmodule