`include "src/semaphore_counter.v"

module tb_semaphore_counter;
reg  clk;
reg  reset;
reg  [7:0] init_value;
reg  up_down;

wire [7:0] sema_count;
wire [7:0] queue_count;

semaphore_counter dut (
    .clk       (clk),
    .reset     (reset),
    .init_value(init_value),
    .up_down   (up_down),
    .sema_count(sema_count),
    .queue_count(queue_count)
);


always #5 clk = ~clk;
integer seed;
initial seed = 123;

initial begin
    $dumpfile("public/vcd/tb_semaphore_counter.vcd");
    $dumpvars(0, dut);

    clk        = 0;
    reset      = 1;
    init_value = 8'd0;
    up_down    = 1'b0;

    $display("\n=== Semaphore Counter Testbench ===\n");
    $display("|%-9s|%-5s|%-9s|%-11s|%-9s|%-11s|%-11s|",
             "Time","clk","reset","init_value","up_down","sema_count","queue_count");
    $display("|---------|-----|---------|-----------|---------|------------|------------|");
    $monitor("|%-9t|%-5b|%-9b|%-11d|%-9b|%-11d|%-11d|",
             $time, clk, reset, init_value, up_down, sema_count, queue_count);

    // ==================================================================
    // Test 1: Basic DOWN/UP (init = 3)
    // ==================================================================
    reset = 1; init_value = 8'd3; up_down = 1'b0; #10;
    reset = 0;

    repeat (3) begin up_down = 1'b0; #10; end // sema: 3 to 0
    up_down = 1'b0; #10;                       // queue: 0 to 1
    up_down = 1'b1; #10;                       // wake
    up_down = 1'b1; #10;                       // sema: 0 to 1

    $monitoroff;
    if (sema_count === 1 && queue_count === 0)
        $display("\n[TEST 1 - Basic DOWN/UP - PASS]\n");
    else
        $display("\n[TEST 1 - Basic DOWN/UP - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 2: DOWN when sema == 0 to queue grows
    // ==================================================================
    reset = 1; init_value = 8'd0; #10; reset = 0;
    repeat (5) begin up_down = 1'b0; #10; end
    $monitoroff;
    if (sema_count === 0 && queue_count === 5)
        $display("\n[TEST 2 - Queue on DOWN (init=0) - PASS]\n");
    else
        $display("\n[TEST 2 - Queue on DOWN - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 3: Queue saturation at 255
    // ==================================================================
    reset = 1; init_value = 8'd0; #10; reset = 0;
    repeat (256) begin up_down = 1'b0; #10; end
    $monitoroff;
    if (sema_count === 0 && queue_count === 255)
        $display("\n[TEST 3 - Queue saturation (255) - PASS]\n");
    else
        $display("\n[TEST 3 - Queue saturation - FAIL] Got queue=%0d\n",
                 queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 4: Reset mid-operation
    // ==================================================================
    reset = 1; init_value = 8'd2; #10; reset = 0;
    up_down = 1'b0; #10; up_down = 1'b0; #10; up_down = 1'b0; #10; // queue = 1
    reset = 1; init_value = 8'd5; #10; reset = 0;
    $monitoroff;
    if (sema_count === 5 && queue_count === 0)
        $display("\n[TEST 4 - Reset mid-operation - PASS]\n");
    else
        $display("\n[TEST 4 - Reset mid-operation - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 6: init = 20 to DOWN 15 to UP 10 to DOWN 12
    // ==================================================================
    reset = 1; init_value = 8'd20; #10; reset = 0;
    repeat (15) begin up_down = 1'b0; #10; end // sema to 5
    repeat (10) begin up_down = 1'b1; #10; end // sema to 15
    repeat (12) begin up_down = 1'b0; #10; end // sema to 3
    $monitoroff;
    if (sema_count === 3 && queue_count === 0)
        $display("\n[TEST 5 - init=20: DOWN15 UP10 DOWN12 - PASS]\n");
    else
        $display("\n[TEST 5 - init=20 - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 6: init = 50 to DOWN 60 to queue=10, UP 12 to sema=2
    // ==================================================================
    reset = 1; init_value = 8'd50; #10; reset = 0;
    repeat (60) begin up_down = 1'b0; #10; end // sema to 0, queue to 10
    repeat (12) begin up_down = 1'b1; #10; end // wake 10 to sema to 2
    $monitoroff;
    if (sema_count === 2 && queue_count === 0)
        $display("\n[TEST 6 - init=50: DOWN60 to queue=10, UP12 to sema=2 - PASS]\n");
    else
        $display("\n[TEST 6 - init=50 - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 7: init = 100 to DOWN 150 to queue=50, UP 60 to sema=10
    // ==================================================================
    reset = 1; init_value = 8'd100; #10; reset = 0;
    repeat (150) begin up_down = 1'b0; #10; end // queue to 50
    repeat (60)  begin up_down = 1'b1; #10; end // sema to 10
    $monitoroff;
    if (sema_count === 10 && queue_count === 0)
        $display("\n[TEST 7 - init=100: DOWN150 to queue=50, UP60 to sema=10 - PASS]\n");
    else
        $display("\n[TEST 7 - init=100 - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 8: init = 255 (max sema_count)
    // ==================================================================
    reset = 1; init_value = 8'd255; #10; reset = 0;
    repeat (200) begin up_down = 1'b0; #10; end // sema to 55
    repeat (50)  begin up_down = 1'b1; #10; end // sema to 105
    $monitoroff;
    if (sema_count === 105 && queue_count === 0)
        $display("\n[TEST 8 - init=255: stays within bounds - PASS]\n");
    else
        $display("\n[TEST 8 - init=255 - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 9: Sema saturation (UP when already at init_value)
    // ==================================================================
    reset = 1; init_value = 8'd7; #10; reset = 0;
    repeat (7) begin up_down = 1'b1; #10; end // sema to 7
    repeat (5) begin up_down = 1'b1; #10; end // should stay 7
    $monitoroff;
    if (sema_count === 7 && queue_count === 0)
        $display("\n[TEST 9 - Sema saturation (UP at max) - PASS]\n");
    else
        $display("\n[TEST 9 - Sema saturation - FAIL] Got sema=%0d, queue=%0d\n",
                 sema_count, queue_count);
    $monitoron;
    print_header();

    // ==================================================================
    // Test 10: Queue full to drop new DOWN
    // ==================================================================
    reset = 1; init_value = 8'd0; #10; reset = 0;
    repeat (255) begin up_down = 1'b0; #10; end // queue to 255
    up_down = 1'b0; #10;                         // 256th DOWN to dropped
    $monitoroff;
    if (queue_count === 255)
        $display("\n[TEST 10 - Queue full, DOWN dropped - PASS]\n");
    else
        $display("\n[TEST 10 - Queue full, DOWN dropped - FAIL] Got queue=%0d\n",
                 queue_count);
    $monitoron;
    print_header();
    // ----------------------------------------------------
    // Finish
    // ----------------------------------------------------
    #20;
    $display("\n=== ALL TESTS COMPLETED SUCCESSFULLY ===\n");
    $finish;
end

task print_header;
begin
    $display("|%-9s|%-5s|%-9s|%-11s|%-9s|%-11s|%-11s|",
             "Time","clk","reset","init_value","up_down","sema_count","queue_count");
    $display("|---------|-----|---------|-----------|---------|------------|------------|");
end
endtask

endmodule