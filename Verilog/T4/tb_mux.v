`include "module_mux.v"
module tb_mux;

  // input port are declared in reg(register)
  reg a,b,c,d;
  reg[1:0] select;

  // output port are declared in wire(net)
  wire out;

  // instantiate design block
  mux4_1 m1(a,b,c,d,select,out);

  initial
    begin
         a=1; b=1; c=1; d=0; select=2'b00;
      #5 a=1; b=1; c=1; d=0; select=2'b01;
      #5 a=1; b=1; c=1; d=0; select=2'b10;
      #5 a=1; b=1; c=1; d=0; select=2'b11;
      $finish;
    end

  initial
      $monitor("time=%0d a=%b b=%b c=%b d=%b select=%b out=%b",$time,a,b,c,d,select,out);
      
endmodule