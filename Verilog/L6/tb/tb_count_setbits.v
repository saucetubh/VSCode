`include "src/count_setbits.v"

module tb_count_setbits;

    // Inputs
    reg  [8:0] X;
    // Outputs
    wire [3:0] count;

    // Instantiate DUT
    count_setbits dut (
        .X(X),
        .count(count)
    );

    initial begin
        $dumpfile("public/vcd/tb_count_setbits.vcd");
        $dumpvars(0, tb_count_setbits);
        
        $display("\nTesting count_setbits\n");
        $display("|%-9s|%-15s|%-9s|%-15s|", 
                 "Time", "X(bin)", "X(dec)", "Count");
        $display("|---------|---------------|---------|---------------|");
        $monitor("|%-9t|%-15b|%-9d|%-15d|", 
                 $time, X, X, count);
        
        X = 9'b000000000; #10; 
        X = 9'b111111111; #10; 
        X = 9'b100000000; #10; 
        X = 9'b000000001; #10; 

        
        X = 9'b000000011; #10; 
        X = 9'b000001111; #10; 
        X = 9'b000111111; #10; 
        X = 9'b011111111; #10; 

        
        X = 9'b101010101; #10; 
        X = 9'b010101010; #10; 
        X = 9'b110011001; #10; 
        X = 9'b001100110; #10; 

        
        X = 9'b001000000; #10; 
        X = 9'b100000100; #10; 
        X = 9'b010010010; #10; 
        X = 9'b001001001; #10; 

       
        X = 9'b111110000; #10; 
        X = 9'b000111110; #10; 
        X = 9'b111001111; #10; 
        X = 9'b101111101; #10; 
        X = 9'b011111110; #10; 

       
        X = 9'b100110011; #10; 
        X = 9'b011001100; #10; 
        X = 9'b111000111; #10; 
        X = 9'b110101011; #10; 
        X = 9'b001111001; #10; 

        $finish;
    end
endmodule
