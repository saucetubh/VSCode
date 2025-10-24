`include "sync_up.v"
module tb_sync_counter;
    reg clk, reset;
    wire [3:0] Q;

    sync_counter uut(clk, reset, Q);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;   
    end

    initial begin
        reset = 1;
        #10 reset = 0;           
        #200 $stop;              
    end

    initial begin
        $monitor("Time = %0t | Q = %b", $time, Q);
    end
endmodule