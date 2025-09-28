`include "src/modified_srlatch.v"

module tb_modified_srlatch;

  reg En, S, R;
  wire Q, Qbar;

  modified_srlatch uut (
    .En(En),
    .S(S),
    .R(R),
    .Q(Q),
    .Qbar(Qbar)
  );

  initial begin
    $dumpfile("public/vcd/tb_modified_srlatch.vcd");
    $dumpvars(0, tb_modified_srlatch);
    
    $display("\nTesting Top Module\n");
    $display("|%-9s|%-9s|%-9s|%-9s|%-9s|%-9s|", 
            "Time", "En", "S", "R", "Q", "Qn");
    $display("|---------|---------|---------|---------|---------|---------|");
    $monitor("|%-9t|%-9b|%-9b|%-9b|%-9b|%-9b|", 
            $time, En, S, R, Q, Qbar);
    En = 0; S = 0; R = 0; #10;
    En = 0; S = 0; R = 1; #10;
    En = 0; S = 1; R = 0; #10;
    En = 0; S = 1; R = 1; #10;

    En = 1; S = 0; R = 0; #10;
    En = 1; S = 0; R = 1; #10;
    En = 1; S = 1; R = 0; #10;
    En = 1; S = 1; R = 1; #10;

    En = 0; S = 1; R = 0; #10;
    En = 0; S = 1; R = 1; #10;
    En = 0; S = 0; R = 1; #10;
    En = 0; S = 1; R = 1; #10;

    En = 1; S = 0; R = 0; #10;
    En = 0; S = 1; R = 0; #10;

    $finish;
  end
endmodule
