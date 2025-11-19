// tb_grade_assigner.v

`include "src/grade_assigner.v"

module tb_grade_assigner;

    reg  [4:0] score;
    wire [4:0] grade;
    reg [7:0] grade_letter;
    always @(*) begin
        casex (grade)
            5'b10000: grade_letter = "A";
            5'b01000: grade_letter = "B";
            5'b00100: grade_letter = "C";
            5'b00010: grade_letter = "D";
            5'b00001: grade_letter = "F";
            default:  grade_letter = "X"; 
        endcase
    end

    
    grade_assigner DUT (
        .score(score),
        .grade(grade)
    );

    initial begin
        $dumpfile("public/vcd/grade_assigner.vcd");
        $dumpvars(0, tb_grade_assigner);
        
        $display("|%-5s|%-5s|%-12s|%-13s|", "Time", "score", "letter grade", "one-hot grade");
        $display("|-----|-----|------------|-------------|");

        grade_letter = "X";
        $monitor("|%-5d|%-5d|%-12s|%-13b|",
                  $time, score, grade_letter, grade);
        // Score ranges: 0–4, 5–9, 10–17, 18–21, 22–24
        // Try boundaries and inside each region

        // ----------- 0–4  (grade = 00001) -----------
        score = 0;  #10;
        score = 1;  #10;
        score = 4;  #10;

        // ----------- 5–9  (grade = 00010) -----------
        score = 5;  #10;
        score = 6;  #10;
        score = 9;  #10;

        // ----------- 10–17 (grade = 00100) ----------
        score = 10; #10;
        score = 12; #10;
        score = 17; #10;

        // ----------- 18–21 (grade = 01000) ----------
        score = 18; #10;
        score = 20; #10;
        score = 21; #10;

        // ----------- 22–24 (grade = 10000) ----------
        score = 22; #10;
        score = 23; #10;
        score = 24; #10;

        $finish;
    end

    

endmodule
