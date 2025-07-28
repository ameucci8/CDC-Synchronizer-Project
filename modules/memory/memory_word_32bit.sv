module memory_word_32bit (
    input wire clk,
    input wire reset,
    input wire enable,          // Enable signal to select this memory word
    input wire [31:0] d_in,     // 32-bit data input (for initializing or writing)
    output wire [31:0] q_out    // 32-bit data output
);

    // Use the previously created 32-bit register as the memory word
    register_32bit reg32 (
        .clk(clk),
        .reset(reset),
        .enable(enable),        // Enable determines if this memory word is selected
        .d_in(d_in),            // Data input (for write or initialization)
        .q_out(q_out)           // Output of the 32-bit memory word
    );

endmodule