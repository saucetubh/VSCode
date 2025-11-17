module jk(input J, K, En, clk, output reg Q, Qb);
    always @(posedge clk) begin
        if(En) begin
            case({J,K})
                2'b01: begin
                    Q <= 1'b0;
                    Qb <= 1'b1;
                end
                2'b10: begin
                    Q <= 1'b1;                                 
                    Qb <= 1'b0;
                end
                2'b11: begin
                    Q <= ~Q;
                    Qb <= ~Qb;
                end
            endcase
        end
    end

    //how to implement this using logic gates only? i.e no behavioural modelling
endmodule