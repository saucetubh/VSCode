`timescale 1ns/1ps
`include "modules/Q4_universal_shift_register.v"

module tb_universal_shift_register;

    parameter WIDTH = 8;

    reg [WIDTH-1:0] data_in;
    reg [WIDTH-1:0] parallel_in;
    reg serial_in_left;
    reg serial_in_right;
    reg [1:0] mode;

    wire [WIDTH-1:0] data_out;

    // Instantiate the USR
    universal_shift_register #(
        .WIDTH(WIDTH)
    ) uut (
        .data_in(data_in),
        .parallel_in(parallel_in),
        .serial_in_left(serial_in_left),
        .serial_in_right(serial_in_right),
        .mode(mode),
        .data_out(data_out)
    );

    // Helper for expected output
    reg [WIDTH-1:0] expected;

    // Clock-free stimulus
    initial begin
        $display("Time | mode | data_in   | parallel_in | S_in_L | S_in_R | data_out | expected | Correct/Wrong");
        $display("-------------------------------------------------------------------------------");

        // Mode 00: Hold
        data_in = 8'b10101010; parallel_in = 8'b11110000; serial_in_left=0; serial_in_right=0; mode=2'b00; #10;
        expected = data_in;
        $display("%4t | 00   | %b | %b | %b      | %b      | %b | %b | %s", 
                 $time, data_in, parallel_in, serial_in_left, serial_in_right, data_out, expected, 
                 (data_out===expected)?"Correct":"Wrong");

        // Mode 01: Shift Right
        data_in = 8'b10101010; serial_in_left = 1; mode=2'b01; #10;
        expected = {serial_in_left, data_in[WIDTH-1:1]};
        $display("%4t | 01   | %b | %b | %b      | %b      | %b | %b | %s", 
                 $time, data_in, parallel_in, serial_in_left, serial_in_right, data_out, expected, 
                 (data_out===expected)?"Correct":"Wrong");

        // Mode 10: Shift Left
        data_in = 8'b10101010; serial_in_right = 0; mode=2'b10; #10;
        expected = {data_in[WIDTH-2:0], serial_in_right};
        $display("%4t | 10   | %b | %b | %b      | %b      | %b | %b | %s", 
                 $time, data_in, parallel_in, serial_in_left, serial_in_right, data_out, expected, 
                 (data_out===expected)?"Correct":"Wrong");

        // Mode 11: Parallel Load
        parallel_in = 8'b01010101; mode=2'b11; #10;
        expected = parallel_in;
        $display("%4t | 11   | %b | %b | %b      | %b      | %b | %b | %s", 
                 $time, data_in, parallel_in, serial_in_left, serial_in_right, data_out, expected, 
                 (data_out===expected)?"Correct":"Wrong");

        $finish;
    end

endmodule
