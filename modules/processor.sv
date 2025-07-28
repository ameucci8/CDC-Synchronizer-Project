/*

OPCODES:

========================= R FORMAT ==========================

| Opcode  |r source |r target | r dest  |shift amt|  funct  |
|--6 bit--|--5 bit--|--5 bit--|--5 bit--|--5 bit--|--6 bit--|

Mnemoic |           Meaning           |   Opcode  | Funct
add     | Add                         | 0x00      | 0x00
and     | Bitwise AND                 | 0x00      | 0x04
nor     | Bitwise NOR                 | 0x00      | 0x03
xor     | Bitwise XOR                 | 0x00      | 0x06
or      | Bitwise OR                  | 0x00      | 0x05
slt     | Set to 1 if A < B           | 0x00      | 0x0D
sltu    | Set to 1 if A < B (unsigned)| 0x00      | 0x0E
sll     | Logical shift left          | 0x00      | 0x08
srl     | Logical shift right         | 0x00      | 0x09
sra     | Arithmatic shift right      | 0x00      | 0x0C
sub     | Subract                     | 0x00      | 0x01



========================= I FORMAT ==========================

| Opcode  |  source |  dest   |       Immediate  Value      |
|--6 bit--|--5 bit--|--5 bit--|-----------16 bit------------|

Mnemoic |           Meaning           |   Opcode  | Funct
addi    | Add immediate               | 0x08      | NA
andi    | Bitwise AND immediate       | 0x0C      | NA
beq     | Branch if A == B            | 0x04      | NA
blez    | Branch if A <= 0            | 0x06      | NA
bne     | Branch if A != B            | 0x05      | NA
bgtz    | Branch if A > 0             | 0x07      | NA
j       | Jump to address             | 0x02      | NA
jal     | Jump and Link               | 0x03      | NA
jalr    | Jump and link register      | 0x09      | NA
jr      | Jump to address in register | 0x0E      | NA
lw      | Load word                   | 0x23      | NA
ori     | Bitwize OR immediate        | 0x0D      | NA 
slti    | Set to 1 if A < immediate   | 0x0A      | NA
sltiu   | Set to 1 if A < i (unsigned)| 0x0B      | NA
sw      | Store word                  | 0x2B      | NA



*/
module processor#(
    NUM_ROM_ADDRESS = 256,
    NUM_RAM_ADDRESS = 256

)(

    //top level ifc
    input wire clk,
    input wire reset,
    input wire enable,

    //memory ifc
    input wire [31 : 0] ram_data_read_in,
    
    output wire [(NUM_RAM_ADDRESS > 0) ? $clog2(NUM_RAM_ADDRESS) - 1 : 0 : 0] ram_address,
    output wire [31 : 0] ram_data_write_out,
    output wire ram_enable,
    output wire ram_read_write

);

// ===================== //
// FETCHING STATE WIRING //

parameter PC_LENGTH = $clog2(NUM_ROM_ADDRESS);

wire [(PC_LENGTH > 0) ? PC_LENGTH - 1 : 0 : 0] program_counter_address;
wire [(PC_LENGTH > 0) ? PC_LENGTH - 1 : 0 : 0] program_counter_address_added;
wire [(PC_LENGTH > 0) ? PC_LENGTH - 1 : 0 : 0] program_counter_1_operand;
wire [(PC_LENGTH > 0) ? PC_LENGTH - 1 : 0 : 0] program_counter_address_next;
wire [(PC_LENGTH > 0) ? PC_LENGTH - 1 : 0 : 0] program_counter_address_branched;
wire [(PC_LENGTH > 0) ? PC_LENGTH - 1 : 0 : 0] program_counter_address_jumped;

wire [31 : 0] instruction;

// ========================== //
// === DECODE STATE WIRING == //

//R format wires
wire [5 : 0] opcode;
wire [4 : 0] rs; //first source register in register files 
wire [4 : 0] rt; //second source register in register files
wire [4 : 0] rd; //destination register in register files
wire [4 : 0] shift_amount; //shift amount for shift and rotate operations
wire [5 : 0] funct; //function code for control unit in R format

//I format wires
wire [15 : 0] immediate; // immedeitae value in the I format being used

//J fomrat wires
wire [25 : 0] jump_address_immediate; //the address difference that will change the pc

//Control unit signals
wire [3:0] alu_opcode;
wire reg_file_dst;
wire reg_write_enable;
wire alu_src;
wire mem_access;
wire mem_write;
wire mem_to_reg;
wire branch_enable;
wire [1:0] branch_type; 
wire jump;
wire jump_dst;
wire jump_src;

//Branch control unit signals
wire branch_valid;

//intermediate
wire [31 :0] write_back_data; // 32 bit data into the reg files

//Register file wires
wire [4 : 0] reg_file_addr_1;     // 5 bits of address for reg files
wire [4 : 0] reg_file_addr_2;     // 5 bits of address for reg files
wire [4 : 0] reg_file_write_addr; // 5 bits of address for reg files
wire [31 :0] reg_file_write_data; // 32 bit data into the reg files
wire [31 :0] reg_file_data_a;
wire [31 :0] reg_file_data_b;

wire [31 : 0] immediate_32_bit;

wire [31 : 0] alu_input_a;
wire [31 : 0] alu_input_b;


// =========================== //
// === EXECUTE STATE WIRING == //

wire [31 : 0] alu_a;
wire [31 : 0] alu_b;

wire [31 : 0] alu_data_out;
wire alu_zero_flag;
wire alu_carry_flag;
wire alu_overflow_flag;
wire alu_sign_flag;
wire alu_equal_to_flag;

assign alu_a = alu_input_a;
assign alu_b = alu_input_b;

assign ram_enable = mem_access;



// ================ FECTHING STATE ================= //

register #(
    .N(PC_LENGTH)  // [5:0]  for NUM_ROM_ADDRESS = 256
) program_counter (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .D(program_counter_address_next),
    .Q(program_counter_address)
);


adder_n_bit #(
    .N(PC_LENGTH)
) program_counter_adder (
    .a(program_counter_address),
    .b({{(PC_LENGTH-1){1'b0}}, 1'b1}), // incremnenting program counter by 1
    .cin(1'b0),
    .sum(program_counter_address_added),
    .cout(/*nc*/),
    .overflow(/*nc*/)
);


rom #(
    .N(NUM_ROM_ADDRESS)
) instr_mem (
    .address(program_counter_address),
    .data_out(instruction)
);
// ================ FECTHING STATE ================= //
// ------------------------------------------------- //
// ================ DECODING STATE ================= //

//decoding instruction
assign opcode = instruction[31:26];
assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign rd = instruction[15:11];
assign shift_amount = instruction[10:6];
assign funct = instruction[5:0];

assign immediate = instruction[15:0];

assign jump_address_immediate = instruction[25:0];

//decoding register file inputs
assign reg_file_addr_1 = rs;
assign reg_file_addr_2 = rt;

control_unit control_unit_u (
    //inputs
    .opcode(opcode),
    .funct(funct[3:0]), // 4 bits b/c ALU only has 16 operations

    //outputs
    .alu_opcode(alu_opcode),
    .reg_dst(reg_file_dst),
    .reg_write(reg_write_enable),
    .alu_src(alu_src),
    .mem_access(mem_access),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch(branch_enable),
    .branch_type(branch_type),
    .jump(jump),
    .jump_dst(jump_dst),
    .jump_src(jump_src)
);

mux_2_to_1 #(
    .INPUT_BIT_LENGTH(5)
) reg_data_selection_mux (
    .a(rt),  //will choose rt in R format
    .b(rd),  //will choose rd in I format
    .sel(reg_file_dst), 
    .z(reg_file_write_addr)
);

mux_2_to_1 #(
    .INPUT_BIT_LENGTH(32)
) jump_write_dst (
    .a(write_back_data),  
    .b({{(32 - PC_LENGTH){1'b0}}, program_counter_address}),  
    .sel(jump_dst), 
    .z(reg_file_write_data)
);



//accessing register files for A and B into the ALU
register_files #(
    .NUM_ADDRESS(32),  // 32 register files
    .DATA_LENGTH(32)   // 32 bit words 
) reg_files (
    .clk(clk),
    .reset(reset),
    .write_enable(reg_write_enable), 

    .read_address_1(reg_file_addr_1),
    .read_address_2(reg_file_addr_2),
    .write_address(reg_file_write_addr),
    .write_data_in(reg_file_write_data),

    .read_data_out_1(reg_file_data_a),
    .read_data_out_2(reg_file_data_b)
);

sign_extend #(
    .NUM_INPUTS(16),
    .NUM_OUTPUTS(32)
) sign_extend_rt (
    .a(immediate),
    .z(immediate_32_bit)
);

assign alu_input_a = reg_file_data_a;

mux_2_to_1 #(
    .INPUT_BIT_LENGTH(32)
) alu_data_b_selection_mux (
    .a(reg_file_data_b),  //will choose rt in R format
    .b(immediate_32_bit),  //will choose rd in I format
    .sel(alu_src),  
    .z(alu_input_b)
);

// ================ DECODING STATE ================= //
// ------------------------------------------------- //
// ================ EXECUTE STATE ================== //

alu #(
    .N(32) //32 bit alu
) alu_u (
    //inputs
    .a(alu_a),
    .b(alu_b),
    .opcode(alu_opcode),
    
    //outputs
    .out(alu_data_out),
    .zero_flag(alu_zero_flag),
    .carry_flag(alu_carry_flag),
    .overflow_flag(alu_overflow_flag),
    .sign_flag(alu_sign_flag),
    .equal_to_flag(alu_equal_to_flag)
);

branch_control_unit branch_control_unit_u (
    .branch_type(branch_type),
    .zero_flag(alu_zero_flag),
    .sign_flag(alu_sign_flag),
    .branch(branch_enable),
    .branch_valid(branch_valid)
);


mux_2_to_1 #(
    .INPUT_BIT_LENGTH(PC_LENGTH)
) branch_pc_addr_mux (
    .a(program_counter_address_added),
    .b(immediate[PC_LENGTH -1 : 0]),
    .sel(branch_valid),
    .z(program_counter_address_branched)
);


mux_2_to_1 #(
    .INPUT_BIT_LENGTH(PC_LENGTH)
) jump_addr_source_mux  (
    .a(jump_address_immediate[PC_LENGTH -1 : 0]),
    .b(alu_data_out[PC_LENGTH - 1 : 0]),
    .sel(jump_src),
    .z(program_counter_address_jumped)
);

mux_2_to_1 #(
    .INPUT_BIT_LENGTH(PC_LENGTH)
) jump_pc_addr_mux (
    .a(program_counter_address_branched),
    .b(program_counter_address_jumped),
    .sel(jump),
    .z(program_counter_address_next)
);



// ================== EXECUTE STATE ================== //
// --------------------------------------------------- //
// ================ MEM ACCESS STATE ================= //


assign ram_address =        alu_data_out;
assign ram_data_write_out = reg_file_data_b;
assign ram_read_write =     mem_write;

// ================ MEM ACCESS STATE ================= //
// --------------------------------------------------- //
// ================ WRITE BACK STATE ================= //

mux_2_to_1 #(
    .INPUT_BIT_LENGTH(32)
) write_back_selection_mux (
    .a(alu_data_out),
    .b(ram_data_read_in),
    .sel(mem_to_reg),
    .z(write_back_data)
);

endmodule