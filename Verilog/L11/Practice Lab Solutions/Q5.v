module universal_shift_reg_4bit (
    input        clk,
    input        clear,      // asynchronous active-high
    input        MSBin,
    input        LSBin,
    input        S1,
    input        S0,
    input  [3:0] D,          // parallel data in
    output reg [3:0] Q       // register output
);

  // Asynchronous clear, state changes on rising edge of clk
  always @(posedge clk or posedge clear) begin
    if (clear) begin
      Q <= 4'b0000;
    end else begin
      case ({S1, S0})
        2'b00: Q <= Q;                                   // No change
        2'b01: Q <= {MSBin, Q[3], Q[2], Q[1]};           // Shift right
        2'b10: Q <= {Q[2], Q[1], Q[0], LSBin};           // Shift left
        2'b11: Q <= D;                                   // Parallel load
        default: Q <= Q;
      endcase
    end
  end

endmodule