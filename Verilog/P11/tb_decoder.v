`include "decoder.v"
`timescale 1ns/1ps

module tb_decoder;

    // 1-to-2 decoder signals
    reg  I1, En1;
    wire [1:0] O1;

    // 2-to-4 decoder signals
    reg  [1:0] I2;
    reg  En2;
    wire [3:0] O2;

    // 3-to-8 decoder signals
    reg  [3:0] I3;
    reg  En3;
    wire [7:0] O3;

    // Instantiate your updated modules
    dec12 uut1 (.I(I1), .En(En1), .O(O1));
    dec24 uut2 (.I(I2), .En(En2), .O(O2));
    dec38 uut3 (.I(I3), .En(En3), .O(O3));

    initial begin
        $display("\n----- Testing 1-to-2 Decoder -----");
        En1 = 1;
        I1 = 0; #10;  $display("En=%b I=%b -> O=%b", En1, I1, O1);
        I1 = 1; #10;  $display("En=%b I=%b -> O=%b", En1, I1, O1);

        En1 = 0; #10; $display("En=0 disables -> O=%b", O1);



        $display("\n----- Testing 2-to-4 Decoder -----");
        En2 = 1;
        for (integer i = 0; i < 4; i = i + 1) begin
            I2 = i; #10;
            $display("En=%b I=%b -> O=%b", En2, I2, O2);
        end

        En2 = 0; #10;
        $display("En=0 disables -> O=%b", O2);



        $display("\n----- Testing 3-to-8 Decoder -----");
        En3 = 1;
        for (integer j = 0; j < 8; j = j + 1) begin
            I3 = j; #10;
            $display("En=%b I=%b -> O=%b", En3, I3, O3);
        end

        En3 = 0; #10;
        $display("En=0 disables -> O=%b", O3);

        $finish;
    end

endmodule