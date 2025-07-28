`timescale 1ns / 1ps

module soc_tb;

    // Inputs
    reg clk;
    reg reset;
    reg enable;

    // Instantiate the Unit Under Test (UUT)
    soc soc_i (
        .clk(clk), 
        .reset(reset), 
        .enable(enable)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        enable = 0;

        //setting the rom_enable 

        force soc_i.memory_inst.rom1.enable = 1'b1;
        #10;
        //addi R1, R2, 13
        // R2 = R1 + 13 = 0 + 13
        force soc_i.memory_inst.rom1.firmware_data[0] = 32'b001000_00001_00010_00000000_00001101;
        
        //addi R2, R3, 15
        // R3 = R2 + 13 = 15 + 13 = 28
        force soc_i.memory_inst.rom1.firmware_data[1] = 32'b001000_00010_00011_00000000_00001111;
        
        //sw R0, R3,3
        // storing data in R3 into addr = R0 + 3 = 3
        force soc_i.memory_inst.rom1.firmware_data[2] = 32'b101011_00000_00011_00000000_00000011;

        //lw R0, R5, 3
        // loading data in R5 from addr = R0 + 3 = 3 (from memory)
        force soc_i.memory_inst.rom1.firmware_data[3] = 32'b100011_00000_00101_00000000_00000011;

        //andi R6, R5, 3
        // and bitwise. storing into R5 = R5 & 0111
        force soc_i.memory_inst.rom1.firmware_data[4] = 32'b001100_00101_00110_00000000_00000111;

        //add R6, R5, R6
        // writing into R6 = R5 + R6
        force soc_i.memory_inst.rom1.firmware_data[5] = 32'b000000_00101_00110_00110_00000_000000;

        //and R6, R2, R3
        // writing into R6 = R2 & R3
        force soc_i.memory_inst.rom1.firmware_data[6] = 32'b000000_00010_00011_00110_00000_000100;

        //nor R4, R2, R3
        // writing into R4 = ~ (R2 | R3)
        force soc_i.memory_inst.rom1.firmware_data[7] = 32'b000000_00010_00011_00100_00000_000011;

        //xor R6, R2, R3
        // writing into R6 =  ~R2 & R3 | R2 & ~R3)
        force soc_i.memory_inst.rom1.firmware_data[8] = 32'b000000_00010_00011_00110_00000_000110;

        //or R6, R2, R3
        // writing into R6 =  ~R2 & R3 | R2 & ~R3)
        force soc_i.memory_inst.rom1.firmware_data[9] = 32'b000000_00010_00011_00110_00000_000101;

        //slt R6, R2, R3
        // writing into R6 =  R2 < R3
        force soc_i.memory_inst.rom1.firmware_data[10] = 32'b000000_00010_00011_00110_00000_001101;

        //slt R6, R3, R2
        // writing into R6 =  R3 < R2
        force soc_i.memory_inst.rom1.firmware_data[11] = 32'b000000_00011_00010_00110_00000_001101;

        //slt R6, R4, R2
        // writing into R6 =  R4 < R2
        force soc_i.memory_inst.rom1.firmware_data[12] = 32'b000000_00100_00010_00110_00000_001101;

        //sltu R6, R4, R2
        // writing into R6 =  R4 < R2
        force soc_i.memory_inst.rom1.firmware_data[13] = 32'b000000_00100_00010_00110_00000_001110;

        //addi R1, R0, 3
        // writing into R1 = R0 + 3
        force soc_i.memory_inst.rom1.firmware_data[14] = 32'b001000_00000_00001_00000000_00000011;

        //sll R4, R4, R1
        // writing into R4 = R4 << R1
        force soc_i.memory_inst.rom1.firmware_data[15] = 32'b000000_00100_00001_00100_00000_001000;

        //sra R4, R4, R1
        // writing into R4 = R4 >>> R1
        force soc_i.memory_inst.rom1.firmware_data[16] = 32'b000000_00100_00001_00100_00000_001100;

        //sll R4, R4, R1
        // writing into R4 = R4 << R1
        force soc_i.memory_inst.rom1.firmware_data[17] = 32'b000000_00100_00001_00100_00000_001000;

        //sub R6, R3, R4
        // writing into R6 = R3 - R4
        force soc_i.memory_inst.rom1.firmware_data[18] = 32'b000000_00011_00100_00110_00000_000001;

        //beq R6, R3, 17
        // if R6 = R3 then branch to 17
        force soc_i.memory_inst.rom1.firmware_data[19] = 32'b000100_00011_00100_00000000_00010001;

        //sll R4, R4, R1
        // writing into R4 = R4 << R1
        force soc_i.memory_inst.rom1.firmware_data[20] = 32'b000000_00100_00001_00100_00000_001000;

        //blez R4, 20
        // if R6 <= 0 then branch to 20
        force soc_i.memory_inst.rom1.firmware_data[21] = 32'b000110_00100_00100_00000000_00010100;

        //addi R3, R0, 
        // R3 = R0 + 2
        force soc_i.memory_inst.rom1.firmware_data[22] = 32'b001000_00000_00011_00000000_00000010;

        //srl R4, R4, R1
        // writing into R4 = R4 >> R1
        force soc_i.memory_inst.rom1.firmware_data[23] = 32'b000000_00100_00001_00100_00000_001001;

        //bne R4, R3, 23
        // if R6 <= 0 then branch to 23
        force soc_i.memory_inst.rom1.firmware_data[24] = 32'b000101_00100_00011_00000000_00010111;

        //j 27
        // jump to pc = 27
        force soc_i.memory_inst.rom1.firmware_data[25] = 32'b000010_00000_00000_00000000_00011011;

        //sw R0, R3,4 (should be skipped from the jump)
        // storing data in R3 into addr = R0 + 4 = 4
        force soc_i.memory_inst.rom1.firmware_data[26] = 32'b101011_00000_00011_00000000_00000100;

        //sw R0, R2,2 
        // storing data in R2 into addr = R0 + 2 = 2
        force soc_i.memory_inst.rom1.firmware_data[27] = 32'b101011_00000_00010_00000000_00000010;
        
        //addi R4, R0, 31
        // writing into R4 = R0 + 31
        force soc_i.memory_inst.rom1.firmware_data[28] = 32'b001000_00000_00100_00000000_00011111;

        //jr R4
        // jump to pc = R4 = 31
        force soc_i.memory_inst.rom1.firmware_data[29] = 32'b001110_00100_00000_00000000_00000000;

        //sw R0, R3,4 (should be skipped from the jump)
        // storing data in R3 into mem addr = R0 + 4 = 4
        force soc_i.memory_inst.rom1.firmware_data[30] = 32'b101011_00000_00011_00000000_00000100;

        //sw R0, R4, 1
        // storing data in R4 into mem addr = R0 + 1 = 1
        force soc_i.memory_inst.rom1.firmware_data[31] = 32'b101011_00000_00100_00000000_00000001;

        //jal R6, 34
        // jump to pc = 34 and write into R6
        force soc_i.memory_inst.rom1.firmware_data[32] = 32'b000011_00000_00110_00000000_00100010;

        //jalr R6, r1, 34
        // jump to pc = R1 + 34 = 37 and write into R6
        force soc_i.memory_inst.rom1.firmware_data[34] = 32'b001001_00001_00110_00000000_00100010;




        #10;

        force soc_i.memory_inst.rom1.enable = 1'b0;
    
        // Wait for global reset
        #80;
        
        // Apply reset
        reset = 1;
        #10;
        reset = 0;
        
        // Enable the module
        enable = 1;
        
        // Add stimulus here
        #650;
        enable = 0;
        

        // Finish simulation
        #50;
        $stop;
    end
    
    initial begin
        $monitor("rom_address = %d \ninstruction = %b \n\nALU opcode = %b \nbranch valid = %b \nbranch type = %b | zero flag = %b | sign flag = %b | branch = %b\njump dst = %b | pc next = %b \n reg_write_data = %b | reg_write_enable = %b \nalu a = %b \nalu b = %b \nalu data out (mem addr) = %b \n mem write data = %b \n \nreg file 0 = %b \nreg file 1 = %b \nreg file 2 = %b \nreg file 3 = %b \nreg file 4 = %b \nreg file 5 = %b \nreg file 6 = %b \n \nmemory 0: %b \nmemory 1: %b \nmemory 2: %b \nmemory 3: %b \nmemory 4: %b \n \n", 
            soc_i.rom_address,
            soc_i.instruction, 
            soc_i.processor_unpipelined.alu_opcode,
            soc_i.processor_unpipelined.branch_valid,
            soc_i.processor_unpipelined.branch_type,
            soc_i.processor_unpipelined.alu_zero_flag,
            soc_i.processor_unpipelined.alu_sign_flag,
            soc_i.processor_unpipelined.branch_enable,
            soc_i.processor_unpipelined.jump_dst,
            soc_i.processor_unpipelined.program_counter_address_next,
            soc_i.processor_unpipelined.reg_file_write_data,
            soc_i.processor_unpipelined.reg_write_enable,
            soc_i.processor_unpipelined.alu_input_a,
            soc_i.processor_unpipelined.alu_input_b,
            soc_i.processor_unpipelined.alu_data_out,
            soc_i.processor_unpipelined.ram_data_write_out,
            soc_i.processor_unpipelined.reg_files.register_file_memory[0],
            soc_i.processor_unpipelined.reg_files.register_file_memory[1],
            soc_i.processor_unpipelined.reg_files.register_file_memory[2],
            soc_i.processor_unpipelined.reg_files.register_file_memory[3],
            soc_i.processor_unpipelined.reg_files.register_file_memory[4],
            soc_i.processor_unpipelined.reg_files.register_file_memory[5],
            soc_i.processor_unpipelined.reg_files.register_file_memory[6],
            soc_i.memory_inst.ram1.memory[0],
            soc_i.memory_inst.ram1.memory[1],
            soc_i.memory_inst.ram1.memory[2],
            soc_i.memory_inst.ram1.memory[3],
            soc_i.memory_inst.ram1.memory[4]
        );
    end 

    // Clock generation
    always #5 clk = ~clk;

endmodule
