// 5-to-32 Decoder (Behavioral)
module decoder5to32 (
    input  wire [4:0] in,      // 5-bit input
    output reg  [31:0] out     // 32-bit one-hot output
);
    /*
    //best way to implement a decoder is using leftshift operation on binary equivalent of 1. However this isnt exactly behavioral modelling
    always @(*) begin
        out = 1 << in; //automatically typecasts from decimal to binary. Instead of simply 1, can also say 32'b1 i.e 0000.....0001
    end
    */
/*
    always @(*) begin
        out = 32'b0; //default //dont use assign, it fixes the out to that value and doesnt let it change
        case(in) 
            0: out[0]=1'b1;
            1: out[1]=1'b1;
            2: out[2]=1'b1;
            3: out[3]=1'b1;
            4: out[4]=1'b1;
            5: out[5]=1'b1;
            6: out[6]=1'b1;
            7: out[7]=1'b1;
            8: out[8]=1'b1;
            9: out[9]=1'b1;
            10: out[10]=1'b1;
            11: out[11]=1'b1;
            12: out[12]=1'b1;
            13: out[13]=1'b1;
            14: out[14]=1'b1;
            15: out[15]=1'b1;
            16: out[16]=1'b1;
            17: out[17]=1'b1;
            18: out[18]=1'b1;
            19: out[19]=1'b1;
            20: out[20]=1'b1;
            21: out[21]=1'b1;
            22: out[22]=1'b1;
            23: out[23]=1'b1;
            24: out[24]=1'b1;
            25: out[25]=1'b1;
            26: out[26]=1'b1;
            27: out[27]=1'b1;
            28: out[28]=1'b1;
            29: out[29]=1'b1;
            30: out[30]=1'b1;
            31: out[31]=1'b1;
        endcase
    end
*/
    always @(*) begin
        out = 32'b0; //default
        out[in] = 1'b1;
    end
endmodule
