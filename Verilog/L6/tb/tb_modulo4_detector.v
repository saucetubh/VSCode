`include "src/modulo4_detector.v"

module tb_modulo4_detector;
    // Inputs
    reg  [3:0] N;
    // Outputs
    wire [1:0] Y;

    // Instantiate DUT
    modulo4_detector dut (
        N,
        Y
    );

    initial begin
        $dumpfile("public/vcd/tb_modulo4_detector.vcd");
        $dumpvars(0, tb_modulo4_detector);
        
        $display("\nTesting Top Module\n");
        $display("|%-9s|%-9s|%-15s|%-9s|", "Time", "N(dec)", "N(bin)", "Y");
        $display("|---------|---------|---------------|---------|");
        $monitor("|%-9t|%-9d|%-15b|%-9b|", $time, N, N, Y);

        // Apply test values
        N = 4'd0;  #10;   
        N = 4'd1;  #10;   
        N = 4'd2;  #10;   
        N = 4'd3;  #10;   
        N = 4'd4;  #10;   
        N = 4'd5;  #10;   
        N = 4'd6;  #10;   
        N = 4'd7;  #10;   
        N = 4'd8;  #10;   
        N = 4'd9;  #10;   
        N = 4'd10; #10;   
        N = 4'd11; #10;   
        N = 4'd12; #10;   
        N = 4'd13; #10;   
        N = 4'd14; #10;   
        N = 4'd15; #10;   

        $finish;
    end
endmodule
