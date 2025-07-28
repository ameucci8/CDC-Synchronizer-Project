module decoder_1_to_2 (
    input wire address,   // 1-bit address input (for 2 words)
    input wire enable, 
    output wire [1:0] out    // 2 enable lines, one for each memory word
);

    wire inv;
    
    not(inv, address); 
    and(out[0], inv, enable);
    and(out[1], address, enable);

endmodule
