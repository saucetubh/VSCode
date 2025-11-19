module dff0(input clk, rst, d, output reg q);
    always @(posedge clk) begin
        if(rst) q<=1'b0;
        else q<=d;
    end
endmodule

module dff1(input clk, rst, d, output reg q);
    always @(posedge clk) begin
        if(rst) q<=1'b1;
        else q<=d;
    end
endmodule

module ring1(input clk, rst, output [3:0]Q); //structural implementation using d flip flops
    dff0 d1(clk, rst, Q[3], Q[0]);
    dff0 d2(clk, rst, Q[0], Q[1]);
    dff0 d3(clk, rst, Q[1], Q[2]);
    dff1 d4(clk, rst, Q[2], Q[3]); //depending on q, either use dff1 for d4 or d1
endmodule

module ring2(input clk, rst, output reg [3:0]Q);
    always @(posedge clk) begin
        if(rst) Q <= 4'b1000; //depending on q, either use 4'b1000 or 4'b0001
        else Q <= {Q[2:0], Q[3]};
    end
endmodule

module jring1(input clk, rst, output [3:0]Q); //structural implementation using d flip flops
    dff0 d1(clk, rst, ~Q[3], Q[0]);
    dff0 d2(clk, rst, Q[0], Q[1]);
    dff0 d3(clk, rst, Q[1], Q[2]);
    dff1 d4(clk, rst, Q[2], Q[3]); //depending on q, either use dff1 for d4 or d1
endmodule

module jring2(input clk, rst, output reg [3:0]Q);
    always @(posedge clk) begin
        if(rst) Q <= 4'b1000; //depending on q, either use 4'b1000 or 4'b0001
        else Q <= {Q[2:0], ~Q[3]};
    end
endmodule