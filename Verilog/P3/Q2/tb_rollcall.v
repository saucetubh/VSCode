`include "rollcall_match.v"

module tb_rollcall_match;

reg [1:0] S0, S1, S2, S3;
reg [1:0] PAT;
reg MODE;

wire [3:0] MATCH;
wire ANY;
wire PAR;
wire [1:0] FIRST;
wire [1:0] Y;

rollcall r(S0, S1, S2, S3, PAT, MODE, MATCH, ANY, PAR, FIRST, Y);

initial begin
    $dumpfile("tb_rollcall_match.vcd");
    $dumpvars(0, tb_rollcall_match);

    S0 = 2; S1 = 3; S2 = 1; S3 = 0; PAT = 2; MODE = 0;
    // Target = (2,3). Pairs: (2,3), (3,1), (1,0), (0,2). Match at index 0.
    // MATCH=0001, ANY=1, PAR=1, FIRST=00, Y=3

    #10 S0 = 1; S1 = 0; S2 = 3; S3 = 2; PAT = 2; MODE = 1;
    // Target = (2,1). Pairs: (1,0), (0,3), (3,2), (2,1). Match at index 3.
    // MATCH=1000, ANY=1, PAR=1, FIRST=11, Y=1

    #10 S0 = 0; S1 = 1; S2 = 2; S3 = 3; PAT = 0; MODE = 0;
    // Target = (0,1). Pairs: (0,1), (1,2), (2,3), (3,0). Match at index 0.
    // MATCH=0001, ANY=1, PAR=1, FIRST=00, Y=1

    #10 S0 = 3; S1 = 2; S2 = 1; S3 = 0; PAT = 0; MODE = 1;
    // Target = (0,3). Pairs: (3,2), (2,1), (1,0), (0,3). Match at index 3.
    // MATCH=1000, ANY=1, PAR=1, FIRST=11, Y=3

    #10 S0 = 1; S1 = 2; S2 = 3; S3 = 0; PAT = 1; MODE = 0;
    // Target = (1,2). Pairs: (1,2), (2,3), (3,0), (0,1). Match at index 0.
    // MATCH=0001, ANY=1, PAR=1, FIRST=00, Y=2

    #10 S0 = 0; S1 = 3; S2 = 2; S3 = 1; PAT = 3; MODE = 1;
    // Target = (3,2). Pairs: (0,3), (3,2), (2,1), (1,0). Match at index 1.
    // MATCH=0010, ANY=1, PAR=1, FIRST=01, Y=2

    #10 S0 = 3; S1 = 3; S2 = 3; S3 = 3; PAT = 2; MODE = 0;
    // Target = (2,3). All pairs are (3,3). No match.
    // MATCH=0000, ANY=0, PAR=0, FIRST=00, Y=0

    #10 S0 = 0; S1 = 2; S2 = 1; S3 = 3; PAT = 1; MODE = 0;
    // Target = (1,2). Pairs: (0,2), (2,1), (1,3), (3,0). No exact (1,2). No match.
    // MATCH=0000, ANY=0, PAR=0, FIRST=00, Y=0

    #10 S0 = 0; S1 = 3; S2 = 2; S3 = 1; PAT = 2; MODE = 1;
    // Target = (2,1). Pairs: (0,3), (3,2), (2,1), (1,0). Match at index 2.
    // MATCH=0100, ANY=1, PAR=1, FIRST=10, Y=1

    #10 S0 = 0; S1 = 3; S2 = 1; S3 = 2; PAT = 3; MODE = 1;
    // Target = (3,2). Pairs: (0,3), (3,1), (1,2), (2,0). No (3,2). No match.
    // MATCH=0000, ANY=0, PAR=0, FIRST=00, Y=0

    #10 S0 = 2; S1 = 1; S2 = 3; S3 = 0; PAT = 1; MODE = 1;
    // Target = (1,0). Pairs: (2,1), (1,3), (3,0), (0,2). No (1,0). No match.
    // MATCH=0000, ANY=0, PAR=0, FIRST=00, Y=0

    #10 S0 = 0; S1 = 2; S2 = 3; S3 = 1; PAT = 3; MODE = 0;
    // Target = (3,0). Pairs: (0,2), (2,3), (3,1), (1,0). No (3,0). No match.
    // MATCH=0000, ANY=0, PAR=0, FIRST=00, Y=0

    // You can add more test cases if you want
    #20 $finish;
end

initial begin
    // try to understand the difference between %0d and %d, similarly between %0b and %b
    $monitor("S0 S1 S2 S3 = %0d %0d %0d %0d, PAT = %0d, MODE = %0d, MATCH = %b, ANY = %0d, PAR = %0d, FIRST = %b, Y = %0d",
            S0, S1, S2, S3, PAT, MODE, MATCH, ANY, PAR, FIRST, Y);
end

endmodule
