`timescale 1ns/1ps
`include "src/podium_permutations.v"

module tb_podium_permutations;

    wire VALID;
    wire POI;
    wire [7:0] IMAP;
    reg [1:0] N0, N1, N2, N3;

    podium_permutations uut(
        .VALID(VALID),
        .POI(POI),
        .IMAP(IMAP),
        .N0(N0),
        .N1(N1),
        .N2(N2),
        .N3(N3)
    );

    integer i, j, k, l;

    initial begin
        $dumpfile("public/vcd/wave_podium_permutations_imap.vcd");
        $dumpvars(0, tb_podium_permutations);

        #10 // looks good am I right?

        $display("\nTesting Podium Permutations\n");
        $display("|%-5s|%-5s|%-5s|%-5s|%-5s|%-7s|", "Time", "N0", "N1", "N2", "N3", "IMAP");
        $display("|-----|-----|-----|-----|-----|-------|");

        $monitor("|%-5d|%-5d|%-5d|%-5d|%-5d|%-1d %-1d %-1d %-1d|", 
                 $time, N0, N1, N2, N3, IMAP[1:0], IMAP[3:2], IMAP[5:4], IMAP[7:6]);


        for (i = 0; i < 4; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    for (k = 0; k < 4; k = k + 1) begin
                        for (l = 0; l < 4; l = l + 1) begin
                            N0 = i; 
                            N1 = j; 
                            N2 = k; 
                            N3 = l;
                            #10;
                        end
                    end
                end
            end

        $finish;
    end
endmodule
