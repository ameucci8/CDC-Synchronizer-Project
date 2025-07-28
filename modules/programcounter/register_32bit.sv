module register_32bit (
    input wire clk,              // Clock signal
    input wire reset,            // Reset signal
    input wire enable,           // Enable signal (updates register when high)
    input wire [31:0] d_in,      // 32-bit data input
    output wire [31:0] q_out     // 32-bit data output
);

    // Internal wires for Q and Q_bar (not using Q_bar in this case)
    wire [31:0] Q, Q_bar;

    // Generate 32 D flip-flops for each bit of the 32-bit register
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : d_flip_flop_gen
            d_flip_flop dff (
                .clk(clk),
                .reset(reset),
                .D(d_in[i]),      // Data input for each bit
                .Q(Q[i]),         // Output for each bit
                .Q_bar(Q_bar[i])  // Complement (not used)
            );
        end
    endgenerate

    // Assign the output of the register
    assign q_out = Q;

endmodule