module fifo_read_pointer_empty #(
    parameter NUM_ADDRESS = 8 //must be a log base 2 number
)(
    input wire read_clk,
    input wire read_enable,
    input wire read_reset,

    input wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] write_pointer_sync, //in gary code 
    
    output wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] read_pointer, //in gray code
    output wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] read_address, //in binary
    output wire fifo_empty
);

parameter POINTER_LENGTH = $clog2(NUM_ADDRESS) + 1;
parameter ADDRESS_LENGTH = $clog2(NUM_ADDRESS);

wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] xor_comparison;
wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] new_read_pointer;
wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] read_pointer_binary;
wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] read_pointer_ungrayed;

wire empty_not;
wire register_enable;

//comparing read and write pointers
xor_op #(
    .N(POINTER_LENGTH)
) xor1 (
    .a(write_pointer_sync),
    .b(read_pointer),
    .out(xor_comparison)
);

or_n_to_1 #(
    .NUM_INPUTS(POINTER_LENGTH)
) or1 (
    .a(xor_comparison),
    .out(empty_not)
);

not (fifo_empty, empty_not);

//generating enable for register
and(register_enable, empty_not, read_enable);


//converting read pointer to binary for the increment
gray_to_binary #(
    .N(POINTER_LENGTH)
) gtb1 (
    .gray(read_pointer),
    .binary(read_pointer_binary)
);


//incrementing read pointer only if FIFO not empty (if empty = 1, read pointer = read pointer)
adder_n_bit #(
    .N(POINTER_LENGTH)
) adder1 (
    .a(read_pointer_binary),
    .b({POINTER_LENGTH{1'b0}}),
    .cin(1'b1),
    .sum(new_read_pointer),
    .cout(/*NC*/),
    .overflow(/*NC*/)
);



//updating read_pointer only if read_clk ticks and the read_en is high
register #(
    .N(POINTER_LENGTH)
) read_address_register (
    .clk(read_clk),              
    .reset(read_reset),           
    .enable(register_enable),
    .D(new_read_pointer),      
    .Q(read_pointer_ungrayed)
);

//converting output to gray for read pointer
binary_to_gray #(
    .N(POINTER_LENGTH)
) btg1 (
    .binary(read_pointer_ungrayed),
    .gray(read_pointer)
);

assign read_address = read_pointer_ungrayed[POINTER_LENGTH - 2 : 0];


endmodule