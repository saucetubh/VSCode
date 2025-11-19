`include "src/autograder.v"

module tb_autograder;
    reg clk = 0;
    reg reset;
    reg stream_in;
    wire [4:0] marks_out;
    wire [4:0] grade_out;

    reg [31:0] KEY;
    reg[31:0] SUBMISSION;
    reg[4:0] EXPECTED_MARKS = 0;
    reg[4:0] EXPECTED_GRADE = 0;
    reg [7:0] grade_char;

    always @(*) begin
        case (grade_out)
            5'b10000: grade_char = "A";
            5'b01000: grade_char = "B";
            5'b00100: grade_char = "C";
            5'b00010: grade_char = "D";
            5'b00001: grade_char = "F";
            default:  grade_char = "?";
        endcase
    end

    reg [7:0] expected_grade_char;

    always @(*) begin
        case (EXPECTED_GRADE)
            5'b10000: expected_grade_char = "A";
            5'b01000: expected_grade_char = "B";
            5'b00100: expected_grade_char = "C";
            5'b00010: expected_grade_char = "D";
            5'b00001: expected_grade_char = "F";
            default:  expected_grade_char = "?";
        endcase
    end

    reg [31:0] reverse32;

    always @(*) begin
        reverse32 = {
            KEY[3:0],
            KEY[7:4],
            KEY[11:8],
            KEY[15:12],
            KEY[19:16],
            KEY[23:20],
            KEY[27:24],
            KEY[31:28]
        };
    end




    autograder DUT (
        .clk(clk),
        .reset(reset),
        .input_stream(stream_in),
        .key(KEY),
        .marks(marks_out),
        .grade(grade_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("public/vvp/autograder.vcd");
        $dumpvars(0, tb_autograder);

        // $display("===============================");
        // $display("Submission AAAA5555,  Key AAAA3456");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'hAAAA5555;
        KEY = 32'h6543AAAA;
        EXPECTED_MARKS = 5'd16; EXPECTED_GRADE = 5'b00100;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 1 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 1 - SUBMISSION %H, KEY %H - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS, expected_grade_char, EXPECTED_GRADE);
        $monitoron;
        // $display("===============================");
        // $display("Submission 700D2755,  Key 7AAD2755");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'h700D2755;
        KEY = 32'h5572DAA7;
        EXPECTED_MARKS = 5'd18; EXPECTED_GRADE = 5'b01000;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                    marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 2 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 2 - SUBMISSION %h, KEY %h - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS, expected_grade_char, EXPECTED_GRADE);
        $monitoron;
        // $display("===============================");
        // $display("Submission DAAD5225,  Key DAAD2525");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'hDAAD5225;
        KEY = 32'h5252DAAD;
        EXPECTED_MARKS = 5'd19; EXPECTED_GRADE = 5'b01000;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                 marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 3 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 3 - SUBMISSION %h, KEY %h - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS,expected_grade_char, EXPECTED_GRADE);
        $monitoron;
        // $display("===============================");
        // $display("Submission 00000000,  Key 527527AA");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'h0;
        KEY = 32'hAA725725;
        EXPECTED_MARKS = 5'd0; EXPECTED_GRADE = 5'b1;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                 marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 4 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 4 - SUBMISSION %h, KEY %h - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS, expected_grade_char, EXPECTED_GRADE);
        $monitoron;
        // $display("===============================");
        // $display("Submission A2D57D22,  Key A3D57F11");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'hA2D57D22;
        KEY = 32'h11F75D3A;
        EXPECTED_MARKS = 5'd14; EXPECTED_GRADE = 5'b00100;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                 marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 5 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 5 - SUBMISSION %h, KEY %h - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS, expected_grade_char, EXPECTED_GRADE);
        $monitoron;

        // $display("===============================");
        // $display("Submission 227DA700,  Key 227D7822");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'h227DA700;
        KEY = 32'h2287D722;
        EXPECTED_MARKS = 5'd13; EXPECTED_GRADE = 5'b00100;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 6 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 6 - SUBMISSION %h, KEY %h - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS, expected_grade_char, EXPECTED_GRADE);
        $monitoron;
        // $display("===============================");
        // $display("Submission 00220252,  Key 55235525");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'h00220252;
        KEY = 32'h52553255;
        EXPECTED_MARKS = 5'd6; EXPECTED_GRADE = 5'b00010;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                 marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 7 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 7 - SUBMISSION %h, KEY %h - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS, expected_grade_char, EXPECTED_GRADE);
        $monitoron;
        // $display("===============================");
        // $display("Submission 77AD5525,  Key 77AD5525");
        // $display("===============================");
        $display("|%-5s|%-5s|%-5s|%-5s|", "Time", "reset", "in", "marks");
        $display("|-----|-----|-----|-----|");
        SUBMISSION = 32'h77AD5525;
        KEY = 32'h5255DA77;
        EXPECTED_MARKS = 5'd24; EXPECTED_GRADE = 5'b10000;
        reset = 1'b1; #20; reset = 1'b0;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b1; #10;
        stream_in = 1'b0; #10;
        stream_in = 1'b1; #10;
        #20;
        $display("|Marks obtained = %d|\n|Grade received = %c (%05b)|", 
                 marks_out, grade_char, grade_out);
        $monitoroff;
        if (marks_out === EXPECTED_MARKS && grade_out === EXPECTED_GRADE)
            $display("\n[TEST 8 - SUBMISSION %h, KEY %h - PASS]\n", SUBMISSION, reverse32);
        else
            $display("\n[TEST 8 - SUBMISSION %h, KEY %h - FAIL] Expected: marks = %d, grade = %c (%b)\n", SUBMISSION, reverse32, EXPECTED_MARKS, expected_grade_char, EXPECTED_GRADE);
        $finish;
    end

    initial begin
        $monitor("|%-5d|%-5b|%-5b|%-5d|",
                 $time, reset, stream_in, marks_out);
    end

endmodule
