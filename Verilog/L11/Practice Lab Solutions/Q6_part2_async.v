module jk_ff (input clk, input j, input k, input clear, output reg q);
  always @(negedge clk or posedge clear) begin
    if (clear)
      q <= 1'b0;
    else begin
      case ({j, k})
        2'b00: q <= q;         // No change
        2'b01: q <= 1'b0;      // Reset
        2'b10: q <= 1'b1;      // Set
        2'b11: q <= ~q;        // Toggle
      endcase
    end
  end
endmodule

module counter(input clk, input clear, output [2:0] Q);
    wire j0, k0, j1, k1, j2, k2;
    assign j0 = 1'b1; // T flip-flop behavior
    assign k0 = 1'b1;
    assign j1 = 1'b1;
    assign k1 = 1'b1;
    assign j2 = 1'b1;
    assign k2 = 1'b1;

    wire internal_reset = clear | (Q[2] & Q[1] & Q[0]);

    jk_ff ff0 (.clk(clk), .j(j0), .k(k0), .clear(internal_reset), .q(Q[0]));
    jk_ff ff1 (.clk(Q[0]), .j(j1), .k(k1), .clear(internal_reset), .q(Q[1]));
    jk_ff ff2 (.clk(Q[1]), .j(j2), .k(k2), .clear(internal_reset), .q(Q[2]));
endmodule