module soc_async (
    input wire p_clk,
    input wire p_enable,
    input wire ram_clk,
    input wire ram_enable,
    input wire reset
);

parameter NUM_ROM_ADDRESS  = 256;
parameter NUM_RAM_ADDRESS  = 256;
parameter FIFO_DATA_LENGTH = $clog2(NUM_RAM_ADDRESS) + 32 +1;
parameter FIFO_DATA_DEPTH  = 8;

wire [31 : 0] ram_data_read;

wire [$clog2(NUM_RAM_ADDRESS) - 1 : 0] ram_address;
wire [31 : 0] ram_data_write;
wire ram_read_write;

wire ram_read_write_sync;
wire [$clog2(NUM_RAM_ADDRESS) - 1 : 0] ram_address_sync;
wire [31 : 0] ram_data_write_sync;

wire [31:0] ram_data_read_sync;

wire p_to_ram_enable;

wire pc_stall_n;
wire p_enable_comb;



processor #(
    .NUM_ROM_ADDRESS(NUM_ROM_ADDRESS),
    .NUM_RAM_ADDRESS(NUM_RAM_ADDRESS)
) processor_unpipelined (
    .clk(p_clk),
    .reset(reset),
    .enable(p_enable_comb),

    .ram_data_read_in(ram_data_read),

    .ram_address(ram_address),
    .ram_data_write_out(ram_data_write),
    .ram_enable(p_to_ram_enable),
    .ram_read_write(ram_read_write)
);


asynchronous_fifo #(
    .NUM_ADDRESS(FIFO_DATA_DEPTH),
    .DATA_LENGTH(FIFO_DATA_LENGTH)
) p_to_ram_fifo (
    .w_clk(p_clk),
    .r_clk(ram_clk),
    .w_en(p_to_ram_enable),
    .r_en(ram_enable),
    .reset(reset),
    .write_data({ram_read_write, ram_address, ram_data_write}),

    .read_data({ram_read_write_sync, ram_address_sync, ram_data_write_sync}),
    .fifo_full(p_to_ram_fifo_full),
    .fifo_empty(p_to_ram_fifo_empty)
);

not(ram_read_write_sync_n, ram_read_write_sync);
and(ram_to_p_write_enable, ram_read_write_sync_n, ram_enable_sync);

asynchronous_fifo #(
    .NUM_ADDRESS(FIFO_DATA_DEPTH),
    .DATA_LENGTH(32)
) ram_to_p_fifo (
    .w_clk(ram_clk),
    .r_clk(p_clk),
    .w_en(ram_to_p_write_enable),
    .r_en(p_enable),
    .reset(reset),
    .write_data(ram_data_read),
    .read_data(ram_data_read_sync),
    .fifo_full(ram_to_p_fifo_full),
    .fifo_empty(ram_to_p_fifo_empty)
);

memory_controller mem_controller(
    .enable(1'b1),
    .reset(reset),

    .ram_clk(ram_clk),
    .fifo_empty_p_to_ram(p_to_ram_fifo_empty),
    .ram_enable(ram_enable),
    .ram_enable_sync(ram_enable_sync),

    .p_clk(p_clk),
    .fifo_empty_ram_to_p(ram_to_p_fifo_empty),
    .p_enable(p_enable),
    .p_to_ram_enable(p_to_ram_enable),
    .read_write(ram_read_write),
    .pc_stall(pc_stall)
);

not(pc_stall_n, pc_stall);

and(p_enable_comb, p_enable, pc_stall_n);

ram #(
    .N(NUM_RAM_ADDRESS)
) ram1 (
    .clk(ram_clk),
    .reset(reset),
    .read_write(ram_read_write_sync),
    .enable(ram_enable_sync),
    .addr(ram_address_sync),
    .data_in(ram_data_write_sync),
    .data_out(ram_data_read)
);

endmodule