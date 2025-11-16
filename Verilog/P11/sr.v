module srl(input S, R, En, output reg Q, Qb);
    always @(*) begin
        if(En) begin
            case({S,R})
                2'b01: begin
                    Q=1'b0;
                    Qb=1'b1;
                end
                2'b10: begin
                    Q=1'b1;
                    Qb=1'b0;
                end
                2'b11: begin
                    Q=1'bx;
                    Qb=1'bx;
                end
                //is it necessary to have memory state case here i.e 2'b00?
            endcase
        end
    end
    /*
    wire S1, R1;
    assign S1 = ~(En&S);
    assign R1 = ~(En&R);
    assign Q = ~(Qb&S1);
    assign Qb = ~(Q&R1);
    */
endmodule

module dl(input d, en, output q, qb);
    srl s1(d, ~d, en, q, qb);
endmodule