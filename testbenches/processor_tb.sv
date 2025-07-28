`timescale 1ns / 1ps

module processor_tb;

parameter NUM_ROM_ADDRESS = 256;
parameter NUM_RAM_ADDRESS = 256;

reg clk; 
reg reset;
reg enable;

reg [31 : 0] instruction;
reg [31 : 0] ram_data_read_in;

wire [$clog2(NUM_ROM_ADDRESS) - 1 : 0] rom_address;
wire [$clog2(NUM_ROM_ADDRESS) - 1 : 0] ram_address;
wire [31 : 0] ram_data_write_out;
wire ram_enable;
wire ram_read_write;

processor #(
    .NUM_ROM_ADDRESS(NUM_ROM_ADDRESS),
    .NUM_RAM_ADDRESS(NUM_RAM_ADDRESS)
) processor_u (
    .clk(clk),
    .reset(reset),
    .enable(enable),

    .instruction(instruction),
    .ram_data_read_in(ram_data_read_in),

    .rom_address(rom_address),
    .ram_address(ram_address),
    .ram_data_write_out(ram_data_write_out),
    .ram_enable(ram_enable),
    .ram_read_write(ram_read_write)
);

initial begin
    clk = 1'b0;
    enable = 1'b0;
    reset = 1'b0;

    instruction = 32'b0;
    //ram_data_read_in = 32'hDEADBABE;

    #10; 
    reset = 1'b1;
    #10; 
    reset = 1'b0;
    enable = 1'b1;
    #10;
    $display("program counter address = %b", processor_u.program_counter.Q);
    $display("next pc address = %b", processor_u.program_counter_adder.sum);
    $display("reg file data a = %b", processor_u.reg_files.read_data_out_1);
    $display("reg file data b = %b", processor_u.reg_files.read_data_out_2);
    $display("");
    #10;
    clk = 1'b1;
    #5;
    //addi R1, R2, 13
    // R2 = R1 + 13 = 0 + 13
    instruction = 32'b001000_00001_00010_00000000_00001101;
    
    #5;
    clk = 1'b0;

    $display("ADDING R2 = R1 + 13:");
    $display("program counter address = %b", processor_u.program_counter.Q);
    $display("next pc address = %b", processor_u.program_counter_adder.sum);
    $display("reg file data a = %b", processor_u.reg_files.read_data_out_1);
    $display("reg file data b = %b", processor_u.reg_files.read_data_out_2);
    $display("register file write data = %b", processor_u.write_back_selection_mux.z);

    $display("Contol signals:");
    $display("alu_opcode = %b", processor_u.control_unit_u.alu_opcode);
    $display("reg_dst = %b", processor_u.control_unit_u.reg_dst);
    $display("reg_write = %b", processor_u.control_unit_u.reg_write);
    $display("alu_src = %b", processor_u.control_unit_u.alu_src);
    $display("mem_read = %b", processor_u.control_unit_u.mem_read);
    $display("mem_write = %b", processor_u.control_unit_u.mem_write);
    $display("mem_to_reg = %b", processor_u.control_unit_u.mem_to_reg);
    $display("branch = %b", processor_u.control_unit_u.branch);
    $display("branch_type = %b", processor_u.control_unit_u.branch_type);
    $display("jump = %b", processor_u.control_unit_u.jump);
    $display("");
    
    #10;

    clk = 1'b1;
    #5;
    //addi R2, R3, 15
    // R3 = R2 + 13 = 15 + 13 = 28
    instruction = 32'b001000_00010_00011_00000000_00001111;

    #5;
    clk = 1'b0;

    $display("ADDING:  R3 = R2 + 15:");
    $display("program counter address = %b", processor_u.program_counter.Q);
    $display("next pc address = %b", processor_u.program_counter_adder.sum);
    $display("reg file data a = %b", processor_u.reg_files.read_data_out_1);
    $display("reg file data b = %b", processor_u.reg_files.read_data_out_2);
    $display("register file write data = %b", processor_u.write_back_selection_mux.z);
    $display("register file write addr = %b", processor_u.reg_files.write_address);

    $display("Contol signals:");
    $display("alu_opcode = %b", processor_u.control_unit_u.alu_opcode);
    $display("reg_dst = %b", processor_u.control_unit_u.reg_dst);
    $display("reg_write = %b", processor_u.control_unit_u.reg_write);
    $display("alu_src = %b", processor_u.control_unit_u.alu_src);
    $display("mem_read = %b", processor_u.control_unit_u.mem_read);
    $display("mem_write = %b", processor_u.control_unit_u.mem_write);
    $display("mem_to_reg = %b", processor_u.control_unit_u.mem_to_reg);
    $display("branch = %b", processor_u.control_unit_u.branch);
    $display("branch_type = %b", processor_u.control_unit_u.branch_type);
    $display("jump = %b", processor_u.control_unit_u.jump);
    $display("");

    #10;


    clk = 1'b1;
    #5;
    //sw R0, R3,3
    // storing data in R3 into addr = R0 + 3 = 3
    instruction = 32'b101011_00000_00011_00000000_00000011;

    #5;
    clk = 1'b0;

    $display("storing data in R3 into addr = R0 + 3 = 3");
    $display("program counter address = %b", processor_u.program_counter.Q);
    $display("next pc address = %b", processor_u.program_counter_adder.sum);
    $display("reg file data a = %b", processor_u.reg_files.read_data_out_1);
    $display("reg file data b = %b", processor_u.reg_files.read_data_out_2);
    $display("register file write data = %b", processor_u.write_back_selection_mux.z);
    $display("register file write addr = %b", processor_u.reg_files.write_address);
    $display("ram address = %b", processor_u.ram_address);
    $display("ram data = %b", processor_u.ram_data_write_out);


    $display("Contol signals:");
    $display("alu_opcode = %b", processor_u.control_unit_u.alu_opcode);
    $display("reg_dst = %b", processor_u.control_unit_u.reg_dst);
    $display("reg_write = %b", processor_u.control_unit_u.reg_write);
    $display("alu_src = %b", processor_u.control_unit_u.alu_src);
    $display("mem_read = %b", processor_u.control_unit_u.mem_read);
    $display("mem_write = %b", processor_u.control_unit_u.mem_write);
    $display("mem_to_reg = %b", processor_u.control_unit_u.mem_to_reg);
    $display("branch = %b", processor_u.control_unit_u.branch);
    $display("branch_type = %b", processor_u.control_unit_u.branch_type);
    $display("jump = %b", processor_u.control_unit_u.jump);
    $display("");

    
    $stop;
end

endmodule
