module mux2to1 (
    input  wire a,       // Input 0
    input  wire b,       // Input 1
    input  wire sel,     
    output reg  y        
);
    always @(*) begin 
        case(sel)
        1'b0: begin
            y=a;
        end
        1'b1: begin
            y=b;
        end
        endcase
    end
endmodule
