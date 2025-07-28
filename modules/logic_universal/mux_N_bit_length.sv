module mux_N_bit_length #(
    NUM_INPUTS = 8, // ============ MUST BE A LOG BASE 2 NUMBER!!!!!!!!!!!! ============ //
    NUM_BITS = 32
) (
    input wire  [(NUM_BITS > 0) ? NUM_BITS -1 : 0 : 0]          a[(NUM_INPUTS > 0) ? NUM_INPUTS-1 : 0 : 0],
    input wire [(NUM_INPUTS > 0) ? $clog2(NUM_INPUTS)-1 : 0 : 0] sel,
    output wire [(NUM_BITS > 0) ? NUM_BITS -1 : 0 : 0]           out
);

wire [(NUM_INPUTS > 0) ? NUM_INPUTS-1 : 0 : 0] a_flipped [(NUM_BITS > 0) ? NUM_BITS -1 : 0 : 0];

genvar i,j;
generate
    for(i = 0; i < NUM_BITS; i = i + 1) begin
        for(j = 0; j < NUM_INPUTS; j = j + 1) begin
            assign a_flipped[i][j] = a[j][i];
        end
        mux #(
            .NUM_INPUTS(NUM_INPUTS)
        ) uut1 (
            .a(a_flipped[i]),
            .sel(sel),
            .out(out[i])
        );
    end
endgenerate
endmodule