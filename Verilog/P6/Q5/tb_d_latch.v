`include "d_latch.v"
module tb_d_latch;

    reg D, En;
    wire Q;

    // Instantiate the D latch
    d_latch uut (
        .D(D),
        .En(En),
        .Q(Q)
    );

    initial begin
        $dumpfile("d_latch_tb.vcd"); // for GTKWave
        $dumpvars(0, tb_d_latch);

        $display("Time | En D | Q");
        $display("----------------");

        // Initial state
        D = 0; En = 0; #10;
        $display("%4t | %b  %b | %b", $time, En, D, Q);

        // Enable latch and set D=1
        En = 1; D = 1; #10;
        $display("%4t | %b  %b | %b", $time, En, D, Q);

        // Change D while enabled
        D = 0; #10;
        $display("%4t | %b  %b | %b", $time, En, D, Q);

        // Disable latch (Q should hold previous value)
        En = 0; D = 1; #10;
        $display("%4t | %b  %b | %b", $time, En, D, Q);

        // Toggle D with En=0 (Q should remain unchanged)
        D = 0; #10;
        $display("%4t | %b  %b | %b", $time, En, D, Q);

        // Re-enable latch (Q should update again)
        En = 1; D = 1; #10;
        $display("%4t | %b  %b | %b", $time, En, D, Q);

        $finish;
    end

endmodule
