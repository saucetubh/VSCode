// universal_shift_register.v
// Combinational Universal Shift Register (USR)
// Modes: 00 = Hold, 01 = Shift Right, 10 = Shift Left, 11 = Parallel Load

module universal_shift_register #(
    parameter WIDTH = 16
)(
    input  wire [WIDTH-1:0] data_in,        // Current data (from outside registers)
    input  wire [WIDTH-1:0] parallel_in,    // Parallel input data
    input  wire             serial_in_left, // For shift right (MSB input)
    input  wire             serial_in_right,// For shift left (LSB input)
    input  wire [1:0]       mode,           
    output wire [WIDTH-1:0] data_out        // Next data value
);

    // Detect invalid ('x') input , default to 0 if false
    wire valid_data = data_in !== {WIDTH{1'bx}};
    
    // You may declare Internal reg for next value if you widh to use case block , since it can only be used inside always block
    // reg [WIDTH-1:0] next_data; //uncomment this for always block
    // Make sure to add Continuous assignment to output, since ouput is not a reg
    //if you do not use always block and stick to combinationaly logic you do not need reg , you may declare your own wires


endmodule
