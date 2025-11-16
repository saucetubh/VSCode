`include "mux.v"
`timescale 1ns/1ps

module tb_muxes;

    // --- mux21 signals ---
    reg  [1:0] I21;
    reg        S1;
    reg        En1;
    wire       Y21;

    // --- mux41 signals ---
    reg  [3:0] I41;
    reg  [1:0] S2;
    reg        En2;
    wire       Y41;

    // --- mux81 signals ---
    reg  [7:0] I81;
    reg [7:0] patterns [7:0];
    reg  [2:0] S3;
    reg        En3;
    wire       Y81;

    // Instantiate DUTs (match your module names/ports)
    mux21 uut21 (.I(I21), .S(S1), .En(En1), .Y(Y21));
    mux41 uut41 (.I(I41), .S(S2), .En(En2), .Y(Y41));
    mux81 uut81 (.I(I81), .S(S3), .En(En3), .Y(Y81));

    // Counters
    integer passed, failed;
    integer i, j, k;

    // --- Verilog-2001 style functions (return 1-bit reg) ---

    // expected for mux21
    function expected21;
        input [1:0] I;
        input S;
        input En;
        begin
            expected21 = En ? (S ? I[1] : I[0]) : 1'b0;
        end
    endfunction

    // expected for mux41
    function expected41;
        input [3:0] I;
        input [1:0] S;
        input En;
        begin
            expected41 = En ? I[S] : 1'b0;
        end
    endfunction

    // expected for mux81
    function expected81;
        input [7:0] I;
        input [2:0] S;
        input En;
        begin
            expected81 = En ? I[S] : 1'b0;
        end
    endfunction

    initial begin
        passed = 0; failed = 0;

        $display("\n===== TEST START: mux21 =====");
        // Exhaustive for mux21: I21 (00..11), S (0/1), En (0/1)
        for (i = 0; i < 4; i = i + 1) begin
            I21 = i; 
            for (j = 0; j < 2; j = j + 1) begin
                S1 = j;
                for (k = 0; k < 2; k = k + 1) begin
                    En1 = k;
                    #5;
                    if (Y21 === expected21(I21, S1, En1)) begin
                        $display("PASS mux21: En=%b I=%b S=%b -> Y=%b", En1, I21, S1, Y21);
                        passed = passed + 1;
                    end else begin
                        $display("FAIL mux21: En=%b I=%b S=%b -> Y=%b (expected %b)", En1, I21, S1, Y21, expected21(I21,S1,En1));
                        failed = failed + 1;
                    end
                end
            end
        end

        $display("\n===== TEST START: mux41 =====");
        // Exhaustive for mux41
        for (i = 0; i < 16; i = i + 1) begin
            I41 = i;
            for (j = 0; j < 4; j = j + 1) begin
                S2 = j;
                for (k = 0; k < 2; k = k + 1) begin
                    En2 = k;
                    #5;
                    if (Y41 === expected41(I41, S2, En2)) begin
                        $display("PASS mux41: En=%b I=%04b S=%b -> Y=%b", En2, I41, S2, Y41);
                        passed = passed + 1;
                    end else begin
                        $display("FAIL mux41: En=%b I=%04b S=%b -> Y=%b (expected %b)", En2, I41, S2, Y41, expected41(I41,S2,En2));
                        failed = failed + 1;
                    end
                end
            end
        end

        $display("\n===== TEST START: mux81 =====");
        // Representative patterns for mux81
        patterns[0] = 8'b00000000;
        patterns[1] = 8'b00000001;
        patterns[2] = 8'b00000010;
        patterns[3] = 8'b00000100;
        patterns[4] = 8'b00001000;
        patterns[5] = 8'b00010000;
        patterns[6] = 8'b11111111;
        patterns[7] = 8'b10101010;

        for (i = 0; i < 8; i = i + 1) begin
            I81 = patterns[i];
            for (j = 0; j < 8; j = j + 1) begin
                S3 = j;
                for (k = 0; k < 2; k = k + 1) begin
                    En3 = k;
                    #5;
                    if (Y81 === expected81(I81, S3, En3)) begin
                        $display("PASS mux81: En=%b I=%08b S=%b -> Y=%b", En3, I81, S3, Y81);
                        passed = passed + 1;
                    end else begin
                        $display("FAIL mux81: En=%b I=%08b S=%b -> Y=%b (expected %b)", En3, I81, S3, Y81, expected81(I81,S3,En3));
                        failed = failed + 1;
                    end
                end
            end
        end

        $display("\n===== TEST SUMMARY =====");
        $display("Passed: %0d, Failed: %0d", passed, failed);
        if (failed == 0) $display("ALL TESTS PASSED.");
        else $display("SOME TESTS FAILED.");

        $finish;
    end

endmodule