module soc (
    input wire clk,
    input wire reset,
    input wire enable
);

parameter NUM_ROM_ADDRESS = 256;
parameter NUM_RAM_ADDRESS = 256;

wire [31 : 0] ram_data_read;

wire [$clog2(NUM_RAM_ADDRESS) - 1 : 0] ram_address;
wire [31 : 0] ram_data_write;
wire ram_enable;
wire ram_read_write;

processor #(
    .NUM_ROM_ADDRESS(NUM_ROM_ADDRESS),
    .NUM_RAM_ADDRESS(NUM_RAM_ADDRESS)
) processor_unpipelined (
    .clk(clk),
    .reset(reset),
    .enable(enable),

    .ram_data_read_in(ram_data_read),

    .ram_address(ram_address),
    .ram_data_write_out(ram_data_write),
    .ram_enable(ram_enable),
    .ram_read_write(ram_read_write)

);

ram #(
    .N(NUM_RAM_ADDRESS)
) ram1 (
    .clk(clk),
    .reset(reset),
    .read_write(ram_read_write),
    .enable(ram_enable),
    .addr(ram_address),
    .data_in(ram_data_write),
    .data_out(ram_data_read)
);

endmodule