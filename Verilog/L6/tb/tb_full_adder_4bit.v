`include "src/full_adder_4bit.v"

module tb_full_adder_4bit;

    // Inputs
    reg [3:0] A, B;

    // Output
    wire [3:0] S;

    // DUT instantiation
    full_adder_4bit dut (
        .A(A),
        .B(B),
        .S(S)
    );

    initial begin
        $dumpfile("public/vcd/tb_full_adder_4bit.vcd");
        $dumpvars(0, tb_full_adder_4bit);
        
        $display("\nTesting Top Module\n");
        $display("|%-9s|%-9s|%-9s|%-9s|%-9s|%-9s|%-9s|", 
                "Time", "A(bin)", "A(dec)", "B(bin)", "B(dec)", "S(bin)", "S(dec)");
        $display("|---------|---------|---------|---------|---------|---------|---------|");
        $monitor("|%-9t|%-9b|%-9d|%-9b|%-9d|%-9b|%-9d|", 
                $time, A, A, B, B, S, S);

        A = 4'b0000; B = 4'b0000;

        #10 A = 4'b0000; B = 4'b0000;   
        #10 A = 4'b0001; B = 4'b0001; 
        #10 A = 4'b0010; B = 4'b0011; 
        #10 A = 4'b0100; B = 4'b0011; 
        #10 A = 4'b0101; B = 4'b0101;  
        #10 A = 4'b0110; B = 4'b0010; 
        #10 A = 4'b0111; B = 4'b0110;  
        #10 A = 4'b1000; B = 4'b0111;   
        #10 A = 4'b1001; B = 4'b0100;  
        #10 A = 4'b1010; B = 4'b0011;   
        #10 A = 4'b1011; B = 4'b0010;   
        #10 A = 4'b1100; B = 4'b0011;   
        #10 A = 4'b1101; B = 4'b0001;   
        #10 A = 4'b1110; B = 4'b0001;   
        #10 A = 4'b1111; B = 4'b0000;   
        #10 A = 4'b0100; B = 4'b1000;  
        #10 A = 4'b0011; B = 4'b1001;  
        #10 A = 4'b0110; B = 4'b1000;  
        #10 A = 4'b0101; B = 4'b0111;  
        #10 A = 4'b0010; B = 4'b1010;   

        $finish;
    end

endmodule
