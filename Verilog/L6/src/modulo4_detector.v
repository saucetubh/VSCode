module modulo4_detector (
    input  [3:0] N,
    output reg [1:0]Y
);
    always @(*) begin
        if(N==0 || N==4 || N==8 || N==12) begin
            Y=0;
        end
        else if(N==1 || N==5 || N==9 || N==13) begin
            Y=1;
        end
        else if(N==2 || N==6 || N==10 || N==14) begin
            Y=2;
        end
        else if(N==3 || N==7 || N==11 || N==15) begin
            Y=3;
        end
    end
    
endmodule
