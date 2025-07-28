module fetch_stage (
    input wire clk,
    input wire reset,
    output wire [31:0] instruction,
    output wire [31:0] pc_out
);

// Signals
reg [31:0] pc;               // program Counter
wire [31:0] next_pc;          // next Program Counter value
wire [31:0] instruction_mem;  // fetched instruction from memory

// Memory read logic 
mem_instruction memory (
    .address(pc),
    .data_out(instruction_mem),
    .read_enable(1'b1)
);

// program counter increment logic
assign next_pc = pc + 4;

// instruction register
reg [31:0] ir;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc <= 32'b0;   // reset PC to 0
        ir <= 32'b0;   // reset IR
    end else begin
        pc <= next_pc; // update PC
        ir <= instruction_mem; // store fetched instruction
    end
end

assign instruction = ir;
assign pc_out = pc;

endmodule
