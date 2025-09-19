`include "module_decoder.v"
module tb_decoder;

  // input port are declared in reg(register)
  reg a,b,en;

  // output port are declared in wire(net)
  wire [3:0]out;

  // instantiate design block
  decoder24_behaviour dut(en,a,b,out);

  initial
    begin
      $dumpfile("out.vcd");
      $dumpvars(0,tb_decoder);

        en=0;a=1'bx;b=1'bx;
      #5 en=1;a=0;b=0;
      #5 en=1;a=0;b=1;
      #5 en=1;a=1;b=0;
      #5 en=1;a=1;b=1;
      $finish;
    end

  initial
    begin
      $monitor("time=%0d en=%b a=%b b=%b out=%b",$time,en,a,b,out);
    end
      
endmodule