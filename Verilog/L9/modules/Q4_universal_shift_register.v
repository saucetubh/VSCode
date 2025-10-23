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
    
    // You may declare Internal reg for next value if you wish to use case block , since it can only be used inside always block
    reg [WIDTH-1:0] next_data; //uncomment this for always block
    // Make sure to add Continuous assignment to output, since ouput is not a reg
    //if you do not use always block and stick to combinationaly logic you do not need reg , you may declare your own wires
    always @(*) begin
        if(valid_data) begin
            case(mode)
                2'b00: next_data = data_in;
                2'b01: begin
                    next_data = data_in >> 1;
                    next_data[WIDTH-1] = serial_in_left;
                end
                2'b10: begin
                    next_data = data_in << 1;
                    next_data[0] = serial_in_right;
                end
                2'b11: next_data = parallel_in;
            endcase
        end
        else next_data = {WIDTH{1'b0}}; //what is this doing? //basically replicates 0, "width" no.of times 
        //next_data = 0; //works because of typecasting
    end
    assign data_out = next_data;
endmodule
