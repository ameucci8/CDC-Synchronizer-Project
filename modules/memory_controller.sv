module memory_controller(
    input  wire enable,
    input  wire reset,

    input  wire ram_clk,
    input  wire fifo_empty_p_to_ram,
    input  wire ram_enable,
    output wire ram_enable_sync,

    input  wire p_clk,
    input  wire fifo_empty_ram_to_p,
    input  wire p_enable,
    input  wire p_to_ram_enable,
    input  wire read_write,
    output wire pc_stall
);

wire p_to_ram_empty_n;
wire ram_enable_d;

wire ram_to_p_empty_n;
wire p_enable_d;

wire ram_data_is_back;

wire read;

wire load_op;



not(p_to_ram_empty_n, fifo_empty_p_to_ram);

and(ram_enable_d, p_to_ram_empty_n, ram_enable);

register #(
    .N(1)
) ram_sync_reg (
    .clk(ram_clk),
    .enable(enable),
    .reset(reset),
    .D(ram_enable_d),
    .Q(ram_enable_sync)
);


not(ram_to_p_empty_n, fifo_empty_ram_to_p);

and(p_enable_d, ram_to_p_empty_n, p_enable);

register #(
    .N(1)
) p_sync_reg (
    .clk(p_clk),
    .enable(enable),
    .reset(reset),
    .D(p_enable_d),
    .Q(ram_data_is_back)
);

not(read, read_write);

and(load_op, p_to_ram_enable, read);

mux_2_to_1 #(
    .INPUT_BIT_LENGTH(1)
) pc_stall_mux (
    .a(load_op),
    .b(1'b0),
    .sel(ram_data_is_back),
    .z(pc_stall)
);


endmodule