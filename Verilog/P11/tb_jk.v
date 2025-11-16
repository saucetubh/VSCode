`include "jk.v"
`timescale 1ns/1ps

module tb_jk;
    reg J, K, En, clk;
    wire Q, Qb;

    // DUT
    jk uut (.J(J), .K(K), .En(En), .clk(clk), .Q(Q), .Qb(Qb));

    // clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // expected model inside TB (keeps deterministic state)
    reg expected_Q;
    reg expected_Qb;

    integer passed, failed;

    // helper task: apply inputs, advance one clock, update expected and check outputs
    task apply_and_check;
        input jj, kk, en_in;
        reg old;
        begin
            // drive inputs
            J = jj; K = kk; En = en_in;

            // wait for rising edge of clock
            @(posedge clk);

            // capture old value (this is what Qb will become)
            old = expected_Q;

            // compute new expected_Q based on enable and (old)
            if (en_in) begin
                case ({jj, kk})
                    2'b01: expected_Q = 1'b0;          // reset
                    2'b10: expected_Q = 1'b1;          // set
                    2'b11: expected_Q = ~old;          // toggle
                    default: expected_Q = old;         // hold
                endcase
            end else begin
                expected_Q = old; // hold when disabled
            end

            // expected Qb <= old (non-blocking style in DUT)
            expected_Qb = old;

            // small delta to let DUT settle
            #1;

            // compare (use case equality to detect x)
            if ((Q === expected_Q) && (Qb === expected_Qb)) begin
                $display("PASS  @%0t : En=%b J=%b K=%b -> Q=%b Qb=%b", $time, en_in, jj, kk, Q, Qb);
                passed = passed + 1;
            end else begin
                $display("FAIL  @%0t : En=%b J=%b K=%b -> Q=%b Qb=%b (expected %b %b)",
                         $time, en_in, jj, kk, Q, Qb, expected_Q, expected_Qb);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("jk_tb.vcd");
        $dumpvars(0, tb_jk);

        passed = 0; failed = 0;

        // initialize expected model to known state (choose 0)
        expected_Q  = 1'b0;
        expected_Qb = 1'b0;

        // initialize signals
        J = 0; K = 0; En = 0;

        #10;

        $display("\n--- Bring DUT to known state by setting Q=1 ---");
        // Set Q = 1
        apply_and_check(1'b1, 1'b0, 1'b1); // J=1,K=0,En=1 -> set

        // Reset Q = 0
        apply_and_check(1'b0, 1'b1, 1'b1); // J=0,K=1,En=1 -> reset

        // Test toggle (J=K=1) twice to show toggling
        apply_and_check(1'b1, 1'b1, 1'b1); // toggle
        apply_and_check(1'b1, 1'b1, 1'b1); // toggle again

        // Test hold (J=K=0) while enabled
        apply_and_check(1'b0, 1'b0, 1'b1); // hold

        // Test disable: change J/K while En=0, outputs must not change
        apply_and_check(1'b1, 1'b0, 1'b0); // En=0, should hold previous
        apply_and_check(1'b0, 1'b1, 1'b0); // still En=0, should hold

        // Enable and set/reset again
        apply_and_check(1'b1, 1'b0, 1'b1); // set
        apply_and_check(1'b0, 1'b1, 1'b1); // reset

        // final toggle test with En=1
        apply_and_check(1'b1, 1'b1, 1'b1); // toggle

        #10;
        $display("\n--- TEST SUMMARY ---");
        $display("Passed: %0d  Failed: %0d", passed, failed);
        if (failed == 0) $display("ALL TESTS PASSED.");
        else $display("SOME TESTS FAILED.");

        $finish;
    end

endmodule