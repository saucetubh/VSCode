// pattern_detector.v //1011 is the pattern to detect
module pattern_detector(
    input wire [3:0] shift_reg_value,
    output wire detected //since output is a wire, combinational logic to be used
);
    assign detected = (shift_reg_value == 4'b1011); //output is high when pattern is detected

endmodule
