module or_n_to_1 #(
    NUM_INPUTS = 8 //number of inputs-to-1 multiplexor
    
) (
    input wire [(NUM_INPUTS > 0) ? NUM_INPUTS-1 : 0 : 0] a,
    output wire out
);

wire [(NUM_INPUTS > 0) ? NUM_INPUTS-1 : 0 : 0] or_inner; // 7:0 (8bits)
assign or_inner[0] = a[0]; // LSB of a
assign out = or_inner[NUM_INPUTS - 1]; // MSB (result) of OR of N to 1

genvar i;
generate
    for(i = 1; i < NUM_INPUTS; i = i + 1) begin                
        or (or_inner[i], or_inner[i-1], a[i]); // OR current indexed bit with right index bit
    end
endgenerate
endmodule