//You can include any module
`include "Q6/adder_3bit.v"
module power_of_two_checker(input [3:0] in, output reg is_power_of_two);
  wire [3:0] s1, s2, s3; //although in adder_3bit, output is reg, but here it is wire because it is not assigned inside always block
  adder_3bit A31({2'b00,in[0]}, {2'b00,in[1]}, s1); //modules cant be instantiated inside always block
  adder_3bit A32({2'b00,in[2]}, {1'b0,1'b0,in[3]}, s2); //adder_3bit A32({0,0,in[2]}, {00,in[3]}, s2); will give error, need to specif with 1'b or 2'b
  adder_3bit A33(s1[2:0], s2[2:0], s3); //00x + 00x will give 0x0 so we can ignore msb of s1 and s2
  always @(*) begin
    /*
    is_power_of_two = 1'b0;
    case(in)
      4'b0001: is_power_of_two = 1'b1;
      4'b0010: is_power_of_two = 1'b1;
      4'b0100: is_power_of_two = 1'b1;
      4'b1000: is_power_of_two = 1'b1;
    endcase
    */ //lengthy and ineffecient for bigger inputs
  if(s3==1) begin
    is_power_of_two=1'b1;
  end
  else begin
    is_power_of_two=1'b0;
  end
  end

endmodule

//reg stores output like in procedural programming
//inside always block, whenever input changes, output is calculated and stored in reg variable

//although adder_3bit has output defined as reg, externally when the module is called, its just a wire taking signals thus using wire s1 to store output of modules work
//inside the modules it is stored procedurally, but outside it has continuous assignment
