module asynchronous_fifo #(
    NUM_ADDRESS = 8,
    DATA_LENGTH = 32
) (
    input wire w_clk,
    input wire r_clk,
    input wire w_en,
    input wire r_en,
    input wire reset,
    input wire [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0] write_data,
    output wire [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0] read_data,
    output wire fifo_full,
    output wire fifo_empty

);

parameter POINTER_LENGTH = $clog2(NUM_ADDRESS) + 1;
parameter ADDRESS_LENGTH = $clog2(NUM_ADDRESS);

//write/read addresses going into FIFO-memory module
wire [(NUM_ADDRESS > 0) ? ADDRESS_LENGTH - 1 : 0 : 0] write_address;
wire [(NUM_ADDRESS > 0) ? ADDRESS_LENGTH - 1 : 0 : 0] read_address;

//pointers coming out of full/empty modules (before first flop)
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] write_pointer_initial; 
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] read_pointer_initial;

//pointer signals between the two flops
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] write_pointer_intermediate;
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] read_pointer_intermediate;

//pointer signals after both flops
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] write_pointer_final;
wire [(NUM_ADDRESS > 0) ? POINTER_LENGTH - 1 : 0 : 0] read_pointer_final;

//AND gate signals
wire fifo_full_inv;
wire fifo_empty_inv;
not(fifo_empty_inv, fifo_empty);
not(fifo_full_inv, fifo_full);

//enable signals that come out of the and gate and into the FIFO memory module
wire w_en_final;
wire r_en_final;
and (w_en_final, w_en, fifo_full_inv);
and (r_en_final, r_en, fifo_empty_inv);

fifo_write_pointer_full #(
    .NUM_ADDRESS(NUM_ADDRESS)
) fifo_write_module (
    .write_clk(w_clk),
    .write_reset(reset),
    .write_enable(w_en),
    .read_pointer_sync(read_pointer_final),
    .write_address(write_address),
    .write_pointer(write_pointer_initial),
    .fifo_full(fifo_full)
);

fifo_read_pointer_empty #(
    .NUM_ADDRESS(NUM_ADDRESS)
) fifo_read_module (
    .read_clk(r_clk),
    .read_reset(reset),
    .read_enable(r_en),
    .write_pointer_sync(write_pointer_final),
    .read_address(read_address),
    .read_pointer(read_pointer_initial),
    .fifo_empty(fifo_empty)
);

fifo_memory #(
    .NUM_ADDRESS(NUM_ADDRESS),
    .DATA_LENGTH(DATA_LENGTH)
) fifo_memory (
    .w_clk(w_clk),
    .r_clk(r_clk),
    .reset(reset),
    .write_enable(w_en_final),
    .read_enable(r_en_final),
    .write_address(write_address),
    .read_address(read_address),
    .write_data_in(write_data),
    .read_data_out(read_data)
);

register #(
    .N(POINTER_LENGTH)
) w_ptr_flop_1 (
    .clk(r_clk),              
    .reset(reset),           
    .enable(1'b1),
    .D(write_pointer_initial),      
    .Q(write_pointer_intermediate)
);

register #(
    .N(POINTER_LENGTH)
) w_ptr_flop_2 (
    .clk(r_clk),              
    .reset(reset),           
    .enable(1'b1),
    .D(write_pointer_intermediate),      
    .Q(write_pointer_final)
);

register #(
    .N(POINTER_LENGTH)
) r_ptr_flop_1 (
    .clk(w_clk),              
    .reset(reset),           
    .enable(1'b1),
    .D(read_pointer_initial),      
    .Q(read_pointer_intermediate)
);

register #(
    .N(POINTER_LENGTH)
) r_ptr_flop_2 (
    .clk(w_clk),              
    .reset(reset),           
    .enable(1'b1),
    .D(read_pointer_intermediate),      
    .Q(read_pointer_final)
);

endmodule