module bus_seats;
    wire [0:7] seats; // 8 seats

    // 1 = occupied, 0 = empty
    assign seats = 8'b10110010;
endmodule
