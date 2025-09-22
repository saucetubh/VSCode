module encoder_8to3(input [7:0] in, output reg [2:0] zone_id);
  integer i;
  always @(*) begin
    zone_id = 3'b000; //default value ->this is important because if no input is high, output should be 000, without this, it will retain its previous value
    for(i=0;i<8;i=i+1) begin
      if(in[i]) begin
        zone_id = i;
      end
    end
  end //for loops not allowed in this lab, thus use case statements
endmodule
