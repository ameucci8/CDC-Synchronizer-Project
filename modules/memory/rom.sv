module rom #(
    N = 64
) (
    input wire  [(N > 0) ? $clog2(N) - 1 : 0 : 0] address,
    output wire [31 : 0] data_out
);

wire enable;
wire [31:0] firmware_data [(N > 0) ? N-1 : 0 : 0];

wire [31:0] memory [(N > 0) ? N-1 : 0 : 0];

genvar i;
generate
    for(i = 0; i < N; i = i + 1) begin
        d_latch #(
            .N(32)
        ) memory_cell (
            .data(firmware_data[i]),
            .enable(enable),
            .Q(memory[i]),
            .Qn(/*nc*/)
        );
    end
endgenerate

mux_N_bit_length #(
    .NUM_INPUTS(N),
    .NUM_BITS(32)
) memory_mux (
    .a(memory),
    .sel(address),
    .out(data_out)
);


endmodule