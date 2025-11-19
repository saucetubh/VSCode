// grade_assigner.v

module grade_assigner(
    input[4:0] score, //0-24
    output reg[4:0] grade
);
    always @(*) begin
        if(score >= 0 && score <= 4) begin
            grade = 5'b00001;
        end
        if(score >= 5 && score <= 9) begin
            grade = 5'b00010;
        end
        if(score >= 10 && score <= 17) begin
            grade = 5'b00100;
        end
        if(score >= 18 && score <= 21) begin
            grade = 5'b01000;
        end
        if(score >= 22 && score <= 24) begin
            grade = 5'b10000;
        end        
    end
    
endmodule