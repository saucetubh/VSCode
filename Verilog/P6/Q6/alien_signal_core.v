`include "Q6/decoder_5to32bit.v"
`include "Q6/power_of_two_checker.v"
`include "Q6/bit_intel_extractor.v"
`include "Q6/d_latch_8bit.v"
`include "Q6/mux_8to1.v"
`include "Q6/encoder_8to3.v"



module alien_signal_core(
  input [4:0] alien_code,
  input latch_enable,
  input [2:0] priority_zone,
  output reg routed_bit,
  output reg alert,
  output reg [2:0] zone_id
);
  //since ill be calling modules here, it needs to be outside always block, and i need output in the module to be declared as wires 
  //internally they will be assigned procedurally, but externally, the modules will continuously send signals (smth like this idk)
  wire [31:0] decoded_code;
  decoder_5to32 D1(alien_code, decoded_code);
  wire valid;
  power_of_two_checker P1(decoded_code[3:0], valid);
  wire [2:0]intelligence;
  bit_intel_extractor B1(decoded_code[19:12], intelligence);
  wire [7:0] latch_code;
  d_latch_8bit DL1(decoded_code[7:0], latch_enable, latch_code);
  wire rbit;
  mux_8to1 M1(latch_code, priority_zone, rbit); //cant use routed_bit since its declared as reg
  wire [2:0]zid;
  encoder_8to3 E1(latch_code, zid);

  always @(*) begin
    routed_bit = rbit;
    zone_id = zid;
    if ((valid == 1'b0) || (intelligence == 3'b000)) begin
      alert = 1'b1;
    end
    else begin
      alert = 1'b0;
    end
  end
endmodule