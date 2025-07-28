module control_unit (
    input wire [5:0] opcode,        //processor opcode
    input wire [3:0] funct,         //ALU opcode
    output wire [3:0] alu_opcode,   //specifies operation done by ALU
    output wire reg_dst,            //specifies whether destination reg is rd (1) or rt (0)
    output wire reg_write,          //specifies if the instruction writes to a register
    output wire alu_src,            //specifies if second operand is immediate (1) or reg (0)
    output wire mem_access,           //specifies if memory is going to be read
    output wire mem_write,          //specifies if memory is being written
    output wire mem_to_reg,         //specifies if we want the output of memory (1) or ALU (0) going into registers
    output wire branch,             //specifies if instruction is branch
    output wire [1:0] branch_type,  //specifies branch type (00 = beq, 01 = bne, 10 = blez, 11 = bgtz)
    output wire jump,               //specifies if instruction is jump
    output wire jump_dst,    //specifies if the jumped pc address will get written into a register
    output wire jump_src            //specifies if the jump address will take the 
);

/*
==================================== OVERVIEW ==========================================
R-Format instructions 
    (ALU operation with operands rs and rt, stored back into rd)
I-Format instructions       
    (ALU)       (ALU operation with operands rs and offset, stored back into rt)
    (LOAD)      (address pulled from memory determined by rs+offset, stored into reg rt)
    (STORE)     (address to store rt into memory determined by rs+offset)  
    (BRANCH)    (branch to address 'offset' if rs and rt are equal)
J-Format instructions 
    (jump to address specified by address field)


====================== Control Signals per Instruction type =============================================================================

Instruction |   Opcode   | ALU_op | RegDst | RegWrite | ALUSrc | MemAccs | MemWrite | MemtoReg | Branch | Branch-type | Jump | JumpDstnation | JumpSrc
R-Type      |   0x00     | funct  |    1   |    1     |   0    |    0    |    0     |    0     |   0    |      00     |  0   |       0       |    0
j           |   0x02     | 0x0F   |    0   |    0     |   0    |    0    |    0     |    0     |   0    |      00     |  1   |       0       |    0 
jal         |   0x03     | 0x00   |    0   |    1     |   1    |    0    |    0     |    0     |   0    |      00     |  1   |       1       |    0 
jalr        |   0x09     | 0x00   |    0   |    1     |   1    |    0    |    0     |    0     |   0    |      00     |  1   |       1       |    1
jr          |   0x0E     | 0x00   |    0   |    0     |   1    |    0    |    0     |    0     |   0    |      00     |  1   |       0       |    1
beq         |   0x04     | 0x01   |    0   |    0     |   0    |    0    |    0     |    0     |   1    |      00     |  0   |       0       |    0 
bne         |   0x05     | 0x01   |    0   |    0     |   0    |    0    |    0     |    0     |   1    |      01     |  0   |       0       |    0
blez        |   0x06     | 0x0F   |    0   |    0     |   0    |    0    |    0     |    0     |   1    |      10     |  0   |       0       |    0
bgtz        |   0x07     | 0x0F   |    0   |    0     |   0    |    0    |    0     |    0     |   1    |      11     |  0   |       0       |    0
addi        |   0x08     | 0x00   |    0   |    1     |   1    |    0    |    0     |    0     |   0    |      00     |  0   |       0       |    0
slti        |   0x0A     | 0x0D   |    0   |    1     |   1    |    0    |    0     |    0     |   0    |      00     |  0   |       0       |    0 
sltiu       |   0x0B     | 0x0E   |    0   |    1     |   1    |    0    |    0     |    0     |   0    |      00     |  0   |       0       |    0
andi        |   0x0C     | 0x04   |    0   |    1     |   1    |    0    |    0     |    0     |   0    |      00     |  0   |       0       |    0 
ori         |   0x0D     | 0x05   |    0   |    1     |   1    |    0    |    0     |    0     |   0    |      00     |  0   |       0       |    0
lw          |   0x23     | 0x00   |    0   |    1     |   1    |    1    |    0     |    1     |   0    |      00     |  0   |       0       |    0 
sw          |   0x2B     | 0x00   |    0   |    0     |   1    |    1    |    1     |    0     |   0    |      00     |  0   |       0       |    0 
*/

wire [15:0] control_table[63:0];
wire [15:0] control_signal;
/*
genvar i;
generate
    for (i = 0; i < 64; i = i + 1) begin   //table initialization
        assign control_table[i] = 16'b1111_000000000000; //no-op for alu, all low signal for control
    end
endgenerate
*/

assign control_table[0]  = {funct, 12'b110000000000}; //opcode = 0x00 (R-Type)
assign control_table[2]  = {4'hF, 12'b000000000100}; //opcode = 0x02 (j)
assign control_table[3]  = {4'hF, 12'b011000000110}; //opcode = 0x03 (jal)
assign control_table[4]  = {4'h1, 12'b000000100000}; //opcode = 0x04 (beq)
assign control_table[5]  = {4'h1, 12'b000000101000}; //opcode = 0x05 (bne)
assign control_table[6]  = {4'hF, 12'b000000110000}; //opcode = 0x06 (blez)
assign control_table[7]  = {4'hF, 12'b000000111000}; //opcode = 0x07 (bgtz)
assign control_table[8]  = {4'h0, 12'b011000000000}; //opcode = 0x08 (addi)
assign control_table[9]  = {4'h0, 12'b011000000111}; //opcode = 0x09 (jalr)
assign control_table[10] = {4'hD, 12'b011000000000}; //opcode = 0x0A (slti)
assign control_table[11] = {4'hE, 12'b011000000000}; //opcode = 0x0B (sltiu)
assign control_table[12] = {4'h4, 12'b011000000000}; //opcode = 0x0C (andi)
assign control_table[13] = {4'h5, 12'b011000000000}; //opcode = 0x0D (ori)
assign control_table[14] = {4'h0, 12'b001000000101}; //opcode = 0x0E (jr)
assign control_table[35] = {4'h0, 12'b011101000000}; //opcode = 0x23 (lw)
assign control_table[43] = {4'h0, 12'b001110000000}; //opcode = 0x2B (sw)

//control table unused:
assign control_table[1] = 16'b1111_000000000000;
assign control_table[15] = 16'b1111_000000000000;
assign control_table[16] = 16'b1111_000000000000;
assign control_table[17] = 16'b1111_000000000000;
assign control_table[18] = 16'b1111_000000000000;
assign control_table[19] = 16'b1111_000000000000;
assign control_table[20] = 16'b1111_000000000000;
assign control_table[21] = 16'b1111_000000000000;
assign control_table[22] = 16'b1111_000000000000;
assign control_table[23] = 16'b1111_000000000000;
assign control_table[24] = 16'b1111_000000000000;
assign control_table[25] = 16'b1111_000000000000;
assign control_table[26] = 16'b1111_000000000000;
assign control_table[27] = 16'b1111_000000000000;
assign control_table[28] = 16'b1111_000000000000;
assign control_table[29] = 16'b1111_000000000000;
assign control_table[30] = 16'b1111_000000000000;
assign control_table[31] = 16'b1111_000000000000;
assign control_table[32] = 16'b1111_000000000000;
assign control_table[33] = 16'b1111_000000000000;
assign control_table[34] = 16'b1111_000000000000;
assign control_table[36] = 16'b1111_000000000000;
assign control_table[37] = 16'b1111_000000000000;
assign control_table[38] = 16'b1111_000000000000;
assign control_table[39] = 16'b1111_000000000000;
assign control_table[40] = 16'b1111_000000000000;
assign control_table[41] = 16'b1111_000000000000;
assign control_table[42] = 16'b1111_000000000000;
assign control_table[44] = 16'b1111_000000000000;
assign control_table[45] = 16'b1111_000000000000;
assign control_table[46] = 16'b1111_000000000000;
assign control_table[47] = 16'b1111_000000000000;
assign control_table[48] = 16'b1111_000000000000;
assign control_table[49] = 16'b1111_000000000000;
assign control_table[50] = 16'b1111_000000000000;
assign control_table[51] = 16'b1111_000000000000;
assign control_table[52] = 16'b1111_000000000000;
assign control_table[53] = 16'b1111_000000000000;
assign control_table[54] = 16'b1111_000000000000;
assign control_table[55] = 16'b1111_000000000000;
assign control_table[56] = 16'b1111_000000000000;
assign control_table[57] = 16'b1111_000000000000;
assign control_table[58] = 16'b1111_000000000000;
assign control_table[59] = 16'b1111_000000000000;
assign control_table[60] = 16'b1111_000000000000;
assign control_table[61] = 16'b1111_000000000000;
assign control_table[62] = 16'b1111_000000000000;
assign control_table[63] = 16'b1111_000000000000;


mux_N_bit_length #(
    .NUM_INPUTS(64),
    .NUM_BITS(16)
) control_mux (
    .a(control_table),
    .sel(opcode),
    .out(control_signal)
);

assign alu_opcode = control_signal[15:12];
assign reg_dst = control_signal[11];
assign reg_write = control_signal[10];
assign alu_src = control_signal[9];
assign mem_access = control_signal[8];
assign mem_write = control_signal[7];
assign mem_to_reg = control_signal[6];
assign branch = control_signal[5];
assign branch_type = control_signal[4:3];
assign jump = control_signal[2];
assign jump_dst = control_signal[1];
assign jump_src = control_signal[0];


endmodule