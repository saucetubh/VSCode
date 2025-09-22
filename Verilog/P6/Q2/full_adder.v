// 1-bit Full Adder (Behavioral)
module full_adder (
    input  wire a,        
    input  wire b,        
    input  wire cin,      
    output reg  sum,      
    output reg  cout      
);
    /*
    always @(*) begin
        if (cin == 1'b0) begin
            sum = a^b; 
            cout = a&b;
        end
        if (cin == 1'b1) begin
            sum = a^b^cin;
            cout = (a&b)|(b&cin)|(a&cin);
        end
    end
    */ //this isnt exactly behavioral modelling
    /*
    always @(*) begin 
        case(cin)
            1'b0: begin
                case({a,b})
                    2'b00: begin 
                        sum=1'b0; 
                        cout=1'b0;
                    end
                    2'b01: begin
                        sum=1'b1; 
                        cout=1'b0;  
                    end
                    2'b10: begin
                        sum=1'b1; 
                        cout=1'b0;
                    end
                    2'b11: begin 
                        sum=1'b0; 
                        cout=1'b1;
                    end
                endcase
            end
            1'b1: begin
                if(a==1'b0 && b==1'b0) begin
                    sum=1'b1;
                    cout=1'b0;
                end
                if((a==1'b1 && b==1'b0) || (a==1'b0 && b==1'b1)) begin
                    sum=1'b0;
                    cout=1'b1;
                end
                if(a==1'b1 && b==1'b1) begin
                    sum=1'b1;
                    cout=1'b1;
                end
            end
        endcase
    end
    */ //this is stupid, behavioral modelling allows for actual addition and stuff
    //reg [1:0] temp;
    always @(*) begin
        /*
        temp = a + b + cin;
        cout = temp[1];
        sum = temp[0];
        */
        {cout, sum} = a + b + cin; 
    end
endmodule

//assign is for continous assignement, but in behavioural modelling with registers, it stores the value, thus assign is illegal