`include "src/conditional_adder.v"

module tb_conditional_adder;

    // Inputs
    reg  [8:0] X;
    reg  [1:0] SEL;

    // Output
    wire [8:0] Y;

    // Instantiate DUT
    conditional_adder dut (
        .X(X),
        .SEL(SEL),
        .Y(Y)
    );

    initial begin
        $dumpfile("public/vcd/tb_conditional_adder.vcd");
        $dumpvars(0, tb_conditional_adder);

        $display("\nTesting conditional_adder\n");
        $display("|%-9s|%-9s|%-9s|%-9s|%-9s|%-9s|", 
                 "Time", "X(bin)", "X(dec)", "SEL", "Y(bin)", "Y(dec)");
        $display("|---------|---------|---------|---------|---------|---------|");
        $monitor("|%-9t|%-9b|%-9d|%-9b|%-9b|%-9d|", 
                 $time, X, X, SEL, Y, Y);

        X = 9'd0;   SEL = 2'b00; #10; 
        X = 9'd5;   SEL = 2'b00; #10; 
        X = 9'd100; SEL = 2'b00; #10; 
        X = 9'd255; SEL = 2'b00; #10; 

       
        X = 9'd0;   SEL = 2'b01; #10; 
        X = 9'd2;   SEL = 2'b01; #10; 
        X = 9'd50;  SEL = 2'b01; #10; 
        X = 9'd200; SEL = 2'b01; #10; 

        
        X = 9'd1;   SEL = 2'b10; #10; 
        X = 9'd7;   SEL = 2'b10; #10; 
        X = 9'd123; SEL = 2'b10; #10; 
        X = 9'd300; SEL = 2'b10; #10; 

        
        X = 9'd0;   SEL = 2'b11; #10; 
        X = 9'd10;  SEL = 2'b11; #10; 
        X = 9'd199; SEL = 2'b11; #10; 
        X = 9'd400; SEL = 2'b11; #10; 

       
        X = 9'b101010101; SEL = 2'b00; #10; 
        X = 9'b010101010; SEL = 2'b01; #10; 
        X = 9'b111111111; SEL = 2'b10; #10; 
        X = 9'b001100110; SEL = 2'b11; #10; 

        $finish;
    end
endmodule
