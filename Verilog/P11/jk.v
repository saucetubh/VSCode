module jk(input J, K, En, clk, output reg Q, Qb);
    always @(posedge clk) begin
        Qb <= Q; //does = and <= make a difference here, compare outputs
        if(En) begin
            case({J,K})
                2'b01: Q <= 1'b0;
                2'b10: Q <= 1'b1;                                 
                2'b11: Q <= ~Q;
            endcase
        end
    end

    //how to implement this using logic gates only? i.e no behavioural modelling
endmodule