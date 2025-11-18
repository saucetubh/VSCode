`include "usr.v"
`include "fa.v"
module serial_multiplier(
    input clk,
    input start,        // 1 = Load inputs, 0 = Run
    input [3:0] A_in,   // Multiplicand
    input [3:0] B_in,   // Multiplier
    output [7:0] Product, // 8-bit Result
    output done
);

    // Internal Wires
    wire [3:0] Q_M, Q_A, Q_Q; // Outputs of registers
    wire [3:0] Sum_out;       // Output of Adder
    wire Cout_bit;            // Carry out from Adder
    reg Carry_Stored;         // To store carry for the shift step

    // Control Signals
    reg [3:0] count;          // Counts steps (need 8 steps for 4 bits: 4 adds + 4 shifts)
    wire is_add_state;        // 1 if we should Add, 0 if Shift
    wire [1:0] mode_A;        // Mode for Register A
    wire [1:0] mode_Q;        // Mode for Register Q

    // -----------------------------------------------------------
    // CONTROL LOGIC (Simple State Machine)
    // -----------------------------------------------------------
    always @(posedge clk or posedge start) begin
        if (start) begin
            count <= 0;
            Carry_Stored <= 0;
        end else begin
            if (count < 8) count <= count + 1;
            
            // Capture Carry only during the ADD state (even counts)
            if (is_add_state) Carry_Stored <= Cout_bit; 
        end
    end

    assign done = (count == 8);
    assign is_add_state = ~count[0]; // Even numbers (0, 2, 4, 6) are ADD steps

    // -----------------------------------------------------------
    // MODE SELECTION LOGIC
    // -----------------------------------------------------------
    // If in ADD state AND Q ends in 1: Load Sum (2'b11). Else: Hold (2'b00) or Shift (2'b01)
    // Actually, simpler: 
    // Even Cycle (Add):   If Q[0]==1, Mode=LOAD(11). Else Mode=HOLD(00).
    // Odd Cycle (Shift):  Mode=SHIFT(01).
    
    assign mode_A = (start) ? 2'b00 : // During start, we use initv, mode doesn't matter much (implied load)
                    (is_add_state && Q_Q[0]) ? 2'b11 : // Load Sum
                    (is_add_state && !Q_Q[0])? 2'b00 : // Do nothing (add 0)
                    2'b01;                             // Shift Right

    assign mode_Q = (start) ? 2'b00 :
                    (is_add_state) ? 2'b00 :           // Hold during add
                    2'b01;                             // Shift Right

    // -----------------------------------------------------------
    // DATAPATH: 3 UNIVERSAL SHIFT REGISTERS
    // -----------------------------------------------------------

    // 1. MULTIPLICAND (Reg M) - Stores A_in, never changes
    usr RegM (
        .clk(clk), .clr(start), 
        .msbin(1'b0), .lsbin(1'b0), .mode(2'b00), // Mode 00 = Hold
        .D(4'b0000), 
        .initv(A_in), // Load A_in on start
        .Q(Q_M)
    );

    // 2. ACCUMULATOR (Reg A) - Stores Upper Half of Product
    usr RegA (
        .clk(clk), .clr(start), 
        .msbin(Carry_Stored), // When shifting, shift in the carry
        .lsbin(1'b0), 
        .mode(mode_A), 
        .D(Sum_out),          // Parallel Load Input comes from Adder
        .initv(4'b0000),      // Reset to 0
        .Q(Q_A)
    );

    // 3. MULTIPLIER (Reg Q) - Stores Lower Half of Product
    usr RegQ (
        .clk(clk), .clr(start), 
        .msbin(Q_A[0]),       // When shifting, LSB of A moves into MSB of Q
        .lsbin(1'b0), 
        .mode(mode_Q), 
        .D(4'b0000), 
        .initv(B_in),         // Load B_in on start
        .Q(Q_Q)
    );

    // -----------------------------------------------------------
    // DATAPATH: ADDER
    // -----------------------------------------------------------
    rca_4bit Adder (
        .A(Q_A),     // Accumulator
        .B(Q_M),     // Multiplicand
        .cin(1'b0), 
        .Sum(Sum_out), 
        .Cout(Cout_bit)
    );

    // Final Output
    assign Product = {Q_A, Q_Q};

endmodule

module rca_4bit(
    input [3:0] A,
    input [3:0] B,
    input cin,
    output [3:0] Sum,
    output Cout
);
    wire c1, c2, c3; // Internal carry wires

    // Structural 4-bit Adder using your 1-bit Full Adders
    fa fa0 (A[0], B[0], cin, Sum[0], c1);
    fa fa1 (A[1], B[1], c1,  Sum[1], c2);
    fa fa2 (A[2], B[2], c2,  Sum[2], c3);
    fa fa3 (A[3], B[3], c3,  Sum[3], Cout);

endmodule