module mux_submodule #(
    NUM_INPUTS = 16
) (
    input wire [(NUM_INPUTS > 1) ? NUM_INPUTS-1 : 0 : 0] a,
    input wire sel,
    output wire [(NUM_INPUTS > 1) ? NUM_INPUTS/2 -1 : 0 : 0] z
);

genvar i;
generate

    for(i = 0; i < NUM_INPUTS/2; i = i + 1)begin
        mux_2_to_1 # (
            .INPUT_BIT_LENGTH(1)
        ) uut1 (
            .a(a[2*i]), 
            .b(a[2*i + 1]), 
            .sel(sel), 
            .z(z[i])
        );
    end


endgenerate

endmodule