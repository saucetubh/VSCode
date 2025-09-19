`include "module_priority_encoder.v"
module tb_encoder;
  reg [7:0]inp;
  reg en;
  wire [2:0]out;
  
  priorityencoder_83 p1(en,inp,out);
  initial
    begin
        $dumpfile("out.vcd");
        $dumpvars(0,tb_encoder);

        en=1; inp=128;
    #5  en=1; inp=64;
    #5  en=1; inp=32;
    #5  en=1; inp=16;
    #5  en=1; inp=9;
    #5  en=0; inp=8'bx;
      $finish;
    end

    initial
        // monitor is used to display the information. 
        begin
            $monitor("time=%0d en=%b inp=%b out=%b",$time,en,inp,out);
        end
endmodule