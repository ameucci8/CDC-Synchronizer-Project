module program_counter (
    input wire clk,              // Clock signal
    input wire reset,            // Reset signal
    input wire pc_write,         // Write enable signal (updates PC when high)
    input wire [31:0] next_pc,   // Next PC value (e.g., for branches/jumps)
    output wire [31:0] pc        // Current PC value
);

    wire [31:0] pc_in;           // Value to be written into the register

    // 32-bit register instance for storing the PC value
    register_32bit pc_register (
        .clk(clk),
        .reset(reset),
        .enable(pc_write),       // Update the register when pc_write is high
        .d_in(pc_in),            // Data input to the register (next PC)
        .q_out(pc)               // Current PC value output
    );

    // Select the next value to load into the PC register
    assign pc_in = next_pc;

endmodule

