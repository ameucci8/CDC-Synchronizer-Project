module fifo_write_pointer_full #(
    parameter NUM_ADDRESS = 8 //must be a log base 2 number
)(
    input wire write_clk,
    input wire write_enable,
    input wire write_reset,

    input wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] read_pointer_sync, //in gary code 
    
    output wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) : 0 : 0] write_pointer, //in gray code
    output wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] write_address, //in binary
    output wire fifo_full

);


parameter POINTER_LENGTH = $clog2(NUM_ADDRESS) + 1;
parameter ADDRESS_LENGTH = $clog2(NUM_ADDRESS);

//comparison flags
wire read_write_not_equal; 
wire read_write_equal;
wire read_write_last_bit_xor;
wire fifo_full_n; 
wire register_enable;

wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] read_address;
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] write_address_all_bits;
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] write_address_incr;
wire [(NUM_ADDRESS > 0) ? ADDRESS_LENGTH - 1 : 0 : 0] read_write_address_comp;

assign write_address = write_address_all_bits[$clog2(NUM_ADDRESS) - 1 : 0];

//obtaining read address in binary
gray_to_binary #(
    .N(POINTER_LENGTH)
) read_pointer_to_read_address (
    .gray(read_pointer_sync),
    .binary(read_address)
);

//checking if the FIFO is full
//by comparing write_address and read_address
xor_op #(
    .N(ADDRESS_LENGTH)
) xor_address(
    .a(read_address[$clog2(NUM_ADDRESS) - 1 : 0]),
    .b(write_address_all_bits[$clog2(NUM_ADDRESS) - 1 : 0]),
    .out(read_write_address_comp)
);

or_n_to_1 #(
    .NUM_INPUTS(ADDRESS_LENGTH)
) fifo_flag_address_comp (
    .a(read_write_address_comp),
    .out(read_write_not_equal)
);

//fifo full flag
not(read_write_equal, read_write_not_equal);

xor(read_write_last_bit_xor, write_address_all_bits[$clog2(NUM_ADDRESS)], read_address[$clog2(NUM_ADDRESS)]);

and(fifo_full, read_write_last_bit_xor, read_write_equal);

//enable for the register
not(fifo_full_n, fifo_full);

and(register_enable, fifo_full_n, write_enable);

//incrementing the write address
adder_n_bit #( 
    .N(POINTER_LENGTH)
) write_address_increment (
    .a(write_address_all_bits),
    .b({POINTER_LENGTH{1'b0}}),
    .cin(1'b1),
    .sum(write_address_incr),
    .cout(/*nc*/),
    .overflow(/*nc*/)
);

register #(
    .N(POINTER_LENGTH)
) write_handler_register (
    .clk(write_clk),              
    .reset(write_reset),           
    .enable(register_enable),
    .D(write_address_incr),      
    .Q(write_address_all_bits)
);

binary_to_gray #(
    .N(POINTER_LENGTH)
) write_addr_to_write_pointer (
    .binary(write_address_all_bits),
    .gray(write_pointer)
);

endmodule