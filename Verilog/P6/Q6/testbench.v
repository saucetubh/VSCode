`include "Q6/alien_signal_core.v"

module tb_alien_signal_core;
  reg [4:0] alien_code;
  reg latch_enable;
  reg [2:0] priority_zone;
  wire routed_bit;
  wire alert;
  wire [2:0] zone_id;

  alien_signal_core uut (
    .alien_code(alien_code),
    .latch_enable(latch_enable),
    .priority_zone(priority_zone),
    .routed_bit(routed_bit),
    .alert(alert),
    .zone_id(zone_id)
  );

  initial begin
    $display("Time | Alien Code | LatchEn | Priority | Routed Bit | Zone ID | Alert");
    $monitor("%4t | %5b      |   %b     |   %3b    |     %b      |   %d     |   %b",
             $time, alien_code, latch_enable, priority_zone, routed_bit, zone_id, alert);

    // Valid one-hot signals (power of two)
    alien_code = 5'd0; latch_enable = 1; priority_zone = 3'd0; #10;
    alien_code = 5'd1; latch_enable = 1; priority_zone = 3'd1; #10;
    alien_code = 5'd2; latch_enable = 1; priority_zone = 3'd2; #10;
    alien_code = 5'd3; latch_enable = 1; priority_zone = 3'd3; #10;

    // Valid signal, not power of two (bit 5 set)
    alien_code = 5'd5; latch_enable = 1; priority_zone = 3'd4; #10;

    // Valid signal, upper bits active (bit 8 set)
    alien_code = 5'd8; latch_enable = 1; priority_zone = 3'd5; #10;

    // Valid signal, middle byte active (bit 12 set)
    alien_code = 5'd12; latch_enable = 1; priority_zone = 3'd6; #10;

    // Valid signal, upper byte active (bit 20 set)
    alien_code = 5'd20; latch_enable = 1; priority_zone = 3'd7; #10;

    // Valid signal, latch disabled
    alien_code = 5'd6; latch_enable = 0; priority_zone = 3'd0; #10;

    // Valid signal, toggle latch
    alien_code = 5'd7; latch_enable = 1; priority_zone = 3'd1; #10;
    latch_enable = 0; #10;
    latch_enable = 1; #10;

    // Valid signal, test zone encoding
    alien_code = 5'd15; latch_enable = 1; priority_zone = 3'd2; #10;

    // Valid signal, test alert due to zero intel score (bit 16 set)
    alien_code = 5'd16; latch_enable = 1; priority_zone = 3'd3; #10;

    $finish;
  end
endmodule
