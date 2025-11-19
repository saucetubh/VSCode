module t_ff (
    input  wire clk,    
    input  wire reset, //active high asynchronous reset
    input  wire t,
    output reg  q
);
    always @(negedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end
endmodule
//T flip flop's output when input is 1, will have a frequency of clk/2
module ripple_counter_4bit (
    input  wire clk,
    input  wire reset,
    output wire [3:0] q
);
    //here we dont have to do anything sequentially, just structurally use the t_ff module and make connections
    t_ff ff0(clk, reset, 1'b1, q[0]); //T is 1 since we are always toggling
    t_ff ff1(q[0], reset, 1'b1, q[1]);
    t_ff ff2(q[1], reset, 1'b1, q[2]);
    t_ff ff3(q[2], reset, 1'b1, q[3]); //MSB
endmodule
//not giving correct output. FIX IT
//FIXED - changed posedge clk to negedge clk in t_ff module, but why? - for up counter, should be negedge, and for down counter, should be posedge

