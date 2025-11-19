// fsm_unzip_mealy.v

module fsm_unzip (
    input clk,
    input reset,
    input in,
    output reg match,
    output reg[3:0] data
);

    // Registers to store the combinational output values
    reg match_c;
    reg[3:0] data_c;

    // ASSIGN VALUES TO MATCH_C AND DATA_C INSTEAD OF MATCH AND DATA
    // FAILURE TO DO THIS WILL RESULT IN UNDEFINED BEHAVIOUR

    // WRITE YOUR CODE HERE
   parameter[4:0] S0=4'b0000, S1=4'b0001, S2=4'b0010, S3=4'b0011, S4=4'b0100, S5=4'b0101, S6=4'b0110, S7=4'b0111, S8=4'b1000, S9=4'b1001, S10=4'b1010;
    reg [3:0]state, next_state;
    always @(posedge clk) begin
        if(reset) state <= S0;
        else state <= next_state;
    end
    always @(*) begin
        case(state)
            S0:begin
                match_c=1'b0;
                if(in) next_state=S2;
                if(~in) next_state=S1;
            end
            S1:begin
                match_c=1'b0;               
                if(in) next_state=S4;
                if(~in) next_state=S3;
            end
            S2:begin
                match_c=1'b0;              
                if(in) next_state=S7;
                if(~in) next_state=S8;
            end
            S3:begin
                match_c=1'b0;              
                if(in) next_state=S6;
                if(~in) next_state=S5;                
            end
            S4:begin
                data=4'b0101;
                match_c=1'b1;
                next_state=S0;
            end
            S5:begin
                data=4'b0111;
                match=1'b1;
                next_state=S0;               
            end
            S6:begin
                data=4'b1101;
                match=1'b1;
                next_state=S0;
            end
            S7:begin
                data=4'b0010;
                match=1'b1;
                next_state=S0;               
            end
            S8:begin
                match=1'b0;
                data=4'bz;                
                if(in) next_state=S10;
                if(~in) next_state=S9;
            end
            S9:begin
                data=4'b1010;
                match=1'b1;
                next_state=S0;           
            end
            S10: begin
                data=4'b0000;
                match=1'b1;
                next_state=S0;            
            end
        endcase
    end


    // ********************************************
    // ***DO NOT MODIFY ANY CODE BELOW THIS PART***
    // ********************************************

    always @(posedge clk) begin
        match <= match_c;
        data  <= data_c;
    end

endmodule