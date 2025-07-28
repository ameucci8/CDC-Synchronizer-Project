module instruction_memory (
    input wire clk,
    input wire reset,
    input wire [2:0] address,        // 3-bit address input (expandable)
    output reg [31:0] instruction    // 32-bit instruction output
);

    wire [7:0] enable;               // Enable signals from the decoder
    wire [31:0] Q [7:0];             // 32-bit data outputs for each memory word

    // Instantiate the 3-to-8 address decoder
    decoder_3_to_8 decoder (
        .address(address),
        .enable(enable)
    );

    // Instantiate 8 memory words (each 32-bit wide)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : memory_gen
            memory_word_32bit mem_word (
                .clk(clk),
                .reset(reset),
                .D(32'h00000000),     // Preload with NOP or specific instruction
                .Q(Q[i])
            );
        end
    endgenerate

    // Select the output based on the enable signals
    always @(*) begin
        case (enable)
            8'b00000001: instruction = Q[0];
            8'b00000010: instruction = Q[1];
            8'b00000100: instruction = Q[2];
            8'b00001000: instruction = Q[3];
            8'b00010000: instruction = Q[4];
            8'b00100000: instruction = Q[5];
            8'b01000000: instruction = Q[6];
            8'b10000000: instruction = Q[7];
            default: instruction = 32'h00000000;  // Default to NOP
        endcase
    end

endmodule
