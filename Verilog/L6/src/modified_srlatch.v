module modified_srlatch (
    input En,
    input S,   
    input R, 
    output reg Q,
    output reg Qbar
);
  always @(*) begin
    if(En == 1'b1) begin
      Q=1'bz;
      Qbar=1'bz;
    end
    else if (En == 1'b0) begin
      case({S,R})
        2'b00: begin
          Q=1'bz;
          Qbar=1'bz;
        end
        2'b01: begin
          Q=1'b0;
          Qbar=1'b1;
        end
        2'b10: begin
          Q=1'b1;
          Qbar=1'b0;
        end
      endcase
    end
  end
endmodule
