`include "sr.v"
`timescale 1ns/1ps

module tb_sr;

    reg S, R, En;
    wire Q, Qb;

    // D-latch signals
    reg D, En_dl;
    wire Qd, Qbd;

    // Instantiate DUT
    srl uut (.S(S), .R(R), .En(En), .Q(Q), .Qb(Qb));

    // Instantiate D-latch DUT (dl module)
    dl uut_dl (.d(D), .en(En_dl), .q(Qd), .qb(Qbd));

    initial begin
        $dumpfile("sr.vcd");
        $dumpvars(0, tb_sr);

        $display("\n===== Testing SR latch with Enable =====");

        // Test En = 0 (should force reset state)
        En = 0;
        S = 0; R = 0; #10;
        $display("En=0 S=%b R=%b -> Q=%b Qb=%b", S, R, Q, Qb);

        S = 1; R = 0; #10;
        $display("En=0 S=%b R=%b -> Q=%b Qb=%b", S, R, Q, Qb);

        S = 0; R = 1; #10;
        $display("En=0 S=%b R=%b -> Q=%b Qb=%b", S, R, Q, Qb);

        // Test En = 1, all SR states
        En = 1;

        // SR = 00 → hold previous (but your combinational version has no memory, so Q stays same)
        S = 0; R = 0; #10;
        $display("En=1 S=0 R=0 -> Q=%b Qb=%b", Q, Qb);

        // SR = 01 → Reset
        S = 0; R = 1; #10;
        $display("En=1 S=0 R=1 -> Q=%b Qb=%b", Q, Qb);
        S = 0; R = 1; #10;
        $display("En=1 S=0 R=1 -> Q=%b Qb=%b", Q, Qb);        
        S = 0; R = 1; #10;
        $display("En=1 S=0 R=1 -> Q=%b Qb=%b", Q, Qb);
        S = 0; R = 0; #10;
        $display("En=1 S=0 R=0 -> Q=%b Qb=%b", Q, Qb);        
        S = 0; R = 0; #10;
        $display("En=1 S=0 R=0 -> Q=%b Qb=%b", Q, Qb);
        // SR = 10 → Set
        S = 1; R = 0; #10;
        $display("En=1 S=1 R=0 -> Q=%b Qb=%b", Q, Qb);
        S = 0; R = 0; #10;
        $display("En=1 S=0 R=0 -> Q=%b Qb=%b", Q, Qb);

        // SR = 11 → Invalid
        S = 1; R = 1; #10;
        $display("En=1 S=1 R=1 -> Q=%b Qb=%b", Q, Qb);

        // ------------------------------
        // Test D-latch (dl)
        // ------------------------------
        $display("\n===== Testing D-latch (dl) =====");

        // Enable = 1, drive D=0 then D=1
        En_dl = 1; D = 0; #10;
        $display("En_dl=1 D=%b -> Qd=%b Qbd=%b", D, Qd, Qbd);

        D = 1; #10;
        $display("En_dl=1 D=%b -> Qd=%b Qbd=%b", D, Qd, Qbd);

        // Now disable enable and change D; latch should hold previous value
        En_dl = 0; D = 0; #10;
        $display("En_dl=0 D=%b (changed) -> Qd=%b Qbd=%b (should hold)", D, Qd, Qbd);

        D = 1; #10;
        $display("En_dl=0 D=%b (changed) -> Qd=%b Qbd=%b (should still hold)", D, Qd, Qbd);

        $display("========= Test Complete =========");

        $finish;
    end

endmodule