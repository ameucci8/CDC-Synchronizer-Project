module memory #(
    NUM_RAM_ADDRESS = 256,
    NUM_ROM_ADDRESS = 256
) (
    input wire clk,
    input wire reset,
    input [(NUM_ROM_ADDRESS > 0) ? $clog2(NUM_ROM_ADDRESS) - 1 : 0 : 0] rom_address,
    input wire [31 : 0] data_reg_to_mem,
    input wire [(NUM_RAM_ADDRESS > 0) ? $clog2(NUM_RAM_ADDRESS) - 1 : 0 : 0] ram_address,
    input wire ram_write,
    input wire ram_enable,
    output wire [31 : 0] rom_out,
    output wire [31 : 0] ram_out

);

ram #(
    .N(NUM_RAM_ADDRESS)
) ram1 (
    .clk(clk),
    .reset(reset),
    .read_write(ram_write),
    .enable(ram_enable),
    .addr(ram_address),
    .data_in(data_reg_to_mem),
    .data_out(ram_out)
);

rom #(
    .N(NUM_ROM_ADDRESS)
) rom1 (
    .address(rom_address),
    .data_out(rom_out)
);

endmodule
