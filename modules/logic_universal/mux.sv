module mux #(
    NUM_INPUTS = 8 //number of inputs-to-1 multiplexor
    // ============ MUST BE A LOG BASE 2 NUMBER!!!!!!!!!!!! ============ // 
) (
    input wire [(NUM_INPUTS > 0) ? NUM_INPUTS-1 : 0 : 0] a ,
    input wire [(NUM_INPUTS > 0) ? $clog2(NUM_INPUTS)-1 : 0 : 0] sel,
    output wire out
);

wire [(NUM_INPUTS > 0) ? 2*NUM_INPUTS - 2 : 0 : 0] mux_out; //internal mux-output wires from one mux to the other

assign mux_out[(NUM_INPUTS > 0) ? NUM_INPUTS-1 : 0 : 0] = a[(NUM_INPUTS > 0) ? NUM_INPUTS-1 : 0 : 0];

assign out = mux_out[2*NUM_INPUTS - 2];

genvar i;
generate
    for(i = NUM_INPUTS; i > 1; i = i / 2) begin                   //iterating by level
        mux_submodule #(
            .NUM_INPUTS(i)
        ) uut1 (
            .a(mux_out[ 2*(NUM_INPUTS - i) + i - 1 : 2*(NUM_INPUTS - i)]),
            .sel(sel[$clog2(NUM_INPUTS / i)]),
            .z(mux_out[ 2*NUM_INPUTS - i/2 - 1 : 2*NUM_INPUTS - i])
        );
    end
endgenerate
endmodule