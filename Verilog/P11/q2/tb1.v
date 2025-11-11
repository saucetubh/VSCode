`include "p1.v"
`timescale 1ns/1ps
module p1_tb;
  reg  [3:0] X;
  wire [3:0] Y;

  // DUT
  p1 dut (.X(X), .Y(Y));

  integer i, errors;

  initial begin
    errors = 0;

    $display("---- BCD to Excess-3: self-check ----");
    for (i = 0; i < 16; i = i + 1) begin
      X = i[3:0];
      #1; // allow combinational settle

      if (i < 10) begin
        if (Y !== ((i + 3) & 4'hF)) begin
          $display("FAIL: X=%0d (%b) -> Y=%b, expected=%b",
                   i, X, Y, (i + 3) & 4'hF);
          errors = errors + 1;
        end else begin
          $display("PASS: X=%0d (%b) -> Y=%b", i, X, Y);
        end
      end else begin
        $display("DC  : X=%0d (%b) -> Y=%b (input 10–15 don't care)", i, X, Y);
      end
    end

    $display("Total errors: %0d", errors);
    $finish;
  end
endmodule