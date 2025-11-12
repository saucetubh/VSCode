// D flip-flop with asynchronous active-high reset
module dff(
  input       clk,
  input       reset,   // async active-high
  input       d,
  output reg  q
);
  always @(posedge clk or posedge reset) begin
    if (reset) q <= 1'b0;
    else       q <= d;
  end
endmodule

// Mod-7 counter (0->1->2->3->4->5->6->0->...)
// - Synchronous next-state logic using DFFs
// - External reset is asynchronous (to match your style)
// - NO internal async-reset on terminal count (avoids skipping 6)
module up_counter(
  input        clk,
  input        reset,          // async active-high
  output [2:0] counter
);
  wire [2:0] d;
  wire A = counter[2];
  wire B = counter[1];
  wire C = counter[0];

  // Detect terminal count 6 (110)
  wire term6 = A & B & ~C;

  // Binary +1 equations, then gate to force 000 when at 6
  assign d[0] = (~C) & ~term6;                 // d0 = !C, except force 0 when at 6
  assign d[1] = (B ^ C) & ~term6;              // d1 = B xor C, gated at 6
  assign d[2] = (A ^ (B & C)) & ~term6;        // d2 = A xor (B&C), gated at 6

  // DFFs (only external reset is asynchronous)
  dff d0(.clk(clk), .reset(reset), .d(d[0]), .q(counter[0]));
  dff d1(.clk(clk), .reset(reset), .d(d[1]), .q(counter[1]));
  dff d2(.clk(clk), .reset(reset), .d(d[2]), .q(counter[2]));
endmodule