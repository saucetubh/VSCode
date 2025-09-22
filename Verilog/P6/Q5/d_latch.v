// D Latch (Behavioral)
module d_latch (
    input  wire D,       // Data input
    input  wire En,      // Enable
    output reg  Q        // Latched output
);

    always @(*) begin
        if(En) begin
            Q=D;
        end
    end

endmodule
