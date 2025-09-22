// 32-to-5 Encoder (Behavioral)
module encoder32to5 (
    input  wire [31:0] in,   // 32-bit one-hot input
    output reg  [4:0] out    // Encoded 5-bit output
);
    /*
    always @(*) begin
        out=5'b0;
        case(1'b1)
        in[0]: out=0;
        in[1]: out=1;
        in[2]: out=2;
        in[3]: out=3;
        in[4]: out=4;
        in[5]: out=5;
        in[6]: out=6;
        in[7]: out=7;
        in[8]: out=8;
        in[9]: out=9;
        in[10]: out=10;
        in[11]: out=11;
        in[12]: out=12;
        in[13]: out=13;
        in[14]: out=14;
        in[15]: out=15;
        in[16]: out=16;
        in[17]: out=17;
        in[18]: out=18;
        in[19]: out=19;
        in[20]: out=20;
        in[21]: out=21;
        in[22]: out=22;
        in[23]: out=23;
        in[24]: out=24;
        in[25]: out=25;
        in[26]: out=26;
        in[27]: out=27;
        in[28]: out=28;
        in[29]: out=29;
        in[30]: out=30;
        in[31]: out=31;
        endcase
        */
    integer i;
    always @(*) begin
        out = 5'b0;
        for(i=0;i<32;i=i+1) begin
            if(in[i]) begin
                out = i; //automatically type casts
            end
        end
    end
    
endmodule
