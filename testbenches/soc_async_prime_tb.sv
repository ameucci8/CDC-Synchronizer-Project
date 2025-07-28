`timescale 1ns / 1ps

module soc_async_prime_tb;

    // Inputs
    reg p_clk;
    reg p_enable;
    
    reg ram_clk;
    reg ram_enable;

    reg reset;

    time start_time;
    time end_time;

    wire [7:0]  prog_count;
    wire [31:0] mem_0;
    wire [31:0] mem_1;
    wire [31:0] mem_2;
    wire [31:0] mem_3;
    wire [31:0] mem_4;

    // Instantiate the Unit Under Test (UUT)
    soc_async soc_i (
        .p_clk(p_clk),
        .p_enable(p_enable),

        .ram_clk(ram_clk),
        .ram_enable(ram_enable),

        .reset(reset)
    );

    parameter N = 32'b0000_0000_0000_0000_0000_0000_0000_1010; //10

    assign prog_count = soc_i.processor_unpipelined.program_counter_address;
    assign mem_0 = soc_i.ram1.memory[0];
    assign mem_1 = soc_i.ram1.memory[1];
    assign mem_2 = soc_i.ram1.memory[2];
    assign mem_3 = soc_i.ram1.memory[3];
    assign mem_4 = soc_i.ram1.memory[4];

    /*

    R Format Template:
        force soc_i.processor_unpipelined.instr_mem.firmware_data[] = 
        {6'b000000, 5'b00000, 5'b00000, 5'b00000, 5'b00000, 6'b000000};
        // Opcode |   rs    |   rt    |   rd    |  shamt  |    funct  |

    I Format Template:
        force soc_i.processor_unpipelined.instr_mem.firmware_data[] = 
        {6'b000000, 5'b00000, 5'b00000, 16'b0000_0000_0000_0000};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

    */

    initial begin
        // Initialize Inputs
        p_clk = 0;
        p_enable = 0;

        ram_clk = 0;
        ram_enable = 0;

        reset = 0;

        //setting the rom_enable 

        force soc_i.processor_unpipelined.instr_mem.enable = 1'b1;
        #10;

        //addi R0, zero, 0
        //R0 = 0 (zero register)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[0] = 
        {6'b001000, 5'b00000, 5'b00000, 16'b0000000000000000};

        //lw R1, zero, 0
        //R1 = mem[0] = N
        force soc_i.processor_unpipelined.instr_mem.firmware_data[1] = 
        {6'b100011, 5'b00000, 5'b00001, 16'b0000000000000000};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R2, zero, 1
        //R2 = 1 (memory index)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[2] = 
        {6'b001000, 5'b00000, 5'b00010, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R3, zero, 2
        //R3 = 2 (i)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[3] = 
        {6'b001000, 5'b00000, 5'b00011, 16'b0000_0000_0000_0010};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R4, R1, 1
        //R4 = N +1
        force soc_i.processor_unpipelined.instr_mem.firmware_data[4] = 
        {6'b001000, 5'b00001, 5'b00100, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //beq R4, R3, 12 
        //exit loop
        force soc_i.processor_unpipelined.instr_mem.firmware_data[5] = 
        {6'b000100, 5'b00100, 5'b00011, 16'b0000_0000_0000_1100};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //jal R31, 50
        //call IsPrime function 
        //jump to 51 and R32 = pc = 6
        force soc_i.processor_unpipelined.instr_mem.firmware_data[6] = 
        {6'b000011, 5'b00000, 5'b11111, 16'b0000_0000_0011_0010};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //beq R7, zero, 10
        //if result R7 == 0, branch to 10
        force soc_i.processor_unpipelined.instr_mem.firmware_data[7] = 
        {6'b000100, 5'b00111, 5'b00000, 16'b0000_0000_0000_1010};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //sw R3, R2, 0
        //mem[R2] = R3
        force soc_i.processor_unpipelined.instr_mem.firmware_data[8] = 
        {6'b101011, 5'b00010, 5'b00011, 16'b0000_0000_0000_0000};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R2, R2, 1
        //R2 = R2 + 1
        force soc_i.processor_unpipelined.instr_mem.firmware_data[9] = 
        {6'b001000, 5'b00010, 5'b00010, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R3, R3, 1
        //R3 = R3 + 1
        force soc_i.processor_unpipelined.instr_mem.firmware_data[10] = 
        {6'b001000, 5'b00011, 5'b00011, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //j 5
        //jump to pc = 5
        force soc_i.processor_unpipelined.instr_mem.firmware_data[11] = 
        {6'b000010, 5'b00000, 5'b00000, 16'b0000_0000_0000_0101};
        // Opcode |   rs    |rt (dest)|     Immediate value     |


        
        // IsPrime Fucntion 

        //addi R5, zero, 2
        //R5 = D = 2
        force soc_i.processor_unpipelined.instr_mem.firmware_data[50] = 
        {6'b001000, 5'b00000, 5'b00101, 16'b0000_0000_0000_0010};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R7, zero, 1
        //R7 = 1 //set result to 0 (asumming i is prime)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[51] = 
        {6'b001000, 5'b00000, 5'b00111, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R6, zero, 1
        //R6 = 1  //set a remainder of 1 in R6
        force soc_i.processor_unpipelined.instr_mem.firmware_data[52] = 
        {6'b001000, 5'b00000, 5'b00110, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //beq R5, R3, 60
        //exit loop if R5 == R3  (D==i)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[53] = 
        {6'b000100, 5'b00101, 5'b00011, 16'b0000_0000_0011_1100};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //add R6, R3, zero 
        //R6 = R3 (R6 = i)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[54] = 
        {6'b000000, 5'b00000, 5'b00011, 5'b00110, 5'b00000, 6'b000000};
        // Opcode |   rs    |   rt    |   rd    |  shamt  |    funct  |
        
        //sub R6, R6, R5
        //R6 = R6 - R5 (D)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[55] = 
        {6'b000000, 5'b00110, 5'b00101, 5'b00110, 5'b00000, 6'b000001};
        // Opcode |   rs    |   rt    |   rd    |  shamt  |    funct  |

        //bgtz R6, 54
        //if R6 > 0, branch to 55
        force soc_i.processor_unpipelined.instr_mem.firmware_data[56] = 
        {6'b000111, 5'b00110, 5'b00000, 16'b0000_0000_0011_0111};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //beq (R6, zero, 60)
        //if R6 (remainder) is 0, exit loop
        force soc_i.processor_unpipelined.instr_mem.firmware_data[57] = 
        {6'b000100, 5'b00110, 5'b00000, 16'b0000_0000_0011_1100};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R5, R5, 1
        //D = D +1
        force soc_i.processor_unpipelined.instr_mem.firmware_data[58] = 
        {6'b001000, 5'b00101, 5'b00101, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //j 52
        //loop back around
        force soc_i.processor_unpipelined.instr_mem.firmware_data[59] = 
        {6'b000010, 5'b00000, 5'b00000, 16'b0000_0000_0011_0100};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //bne R6, zero, 62
        //if R6 != 0 (there is a remainder), then branch to 62
        force soc_i.processor_unpipelined.instr_mem.firmware_data[60] = 
        {6'b000101, 5'b00000, 5'b00110, 16'b0000_0000_0011_1110};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //addi R7, zero, 0 
        //result = 0 (not prime because there is a divisor D)
        force soc_i.processor_unpipelined.instr_mem.firmware_data[61] = 
        {6'b001000, 5'b00000, 5'b00111, 16'b0000_0000_0000_0000};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        //jr R32, 1
        //jump to address in reg + 1
        force soc_i.processor_unpipelined.instr_mem.firmware_data[62] = 
        {6'b001110, 5'b11111, 5'b11110, 16'b0000_0000_0000_0001};
        // Opcode |   rs    |rt (dest)|     Immediate value     |

        
        //filling with no ops
        force soc_i.processor_unpipelined.instr_mem.firmware_data[12] = 32'b0;
        force soc_i.processor_unpipelined.instr_mem.firmware_data[13] = 32'b0;
        force soc_i.processor_unpipelined.instr_mem.firmware_data[14] = 32'b0;
        force soc_i.processor_unpipelined.instr_mem.firmware_data[15] = 32'b0;
        force soc_i.processor_unpipelined.instr_mem.firmware_data[16] = 32'b0;
        force soc_i.processor_unpipelined.instr_mem.firmware_data[17] = 32'b0;


        #10;

        force soc_i.processor_unpipelined.instr_mem.enable = 1'b0;
    
        // Wait for global reset
        #80;
        
        // Apply reset
        reset = 1;
        #10;
        reset = 0;

        force soc_i.ram1.memory[0] = N;
        
        // Enable the module
        p_enable = 1;
        ram_enable = 1;

        wait(soc_i.processor_unpipelined.program_counter_address == 1);
        start_time = $time;

        wait(soc_i.processor_unpipelined.program_counter_address == 12);
        //wait(soc_i.p_to_ram_fifo.fifo_empty == 1);
        end_time = $time;

        #10;
        p_enable = 0;
        ram_enable = 0;
        
        #10;
        $display("\nPrime up to N operation took: %0d ns\n", end_time - start_time);
        $stop;
    end
    
    initial begin
        $monitor("rom_address = %d \ninstruction = %b \n\nALU opcode = %b \nbranch valid = %b \nbranch type = %b | zero flag = %b | sign flag = %b | branch = %b\njump dst = %b | pc next = %b \n reg_write_data = %b | reg_write_enable = %b \nalu a = %b \nalu b = %b \nalu data out (mem addr) = %b \n mem write data = %b \n \nreg file 0 = %b \nreg file 1 = %b \nreg file 2 = %b \nreg file 3 = %b \nreg file 4 = %b \nreg file 5 = %b \nreg file 6 = %b\nreg file 7 = %b \nreg file 31 = %b \n \nmemory 0: %b \nmemory 1: %b \nmemory 2: %b \nmemory 3: %b \nmemory 4: %b \nmemory 5: %b \nmemory 6: %b \nmemory 7: %b \nmemory 8: %b \n \n Async FIFO (p_to_ram): \n w_en = %b | r_en = %b | reset %b | write_data = %b \nread_data = %b | fifo_full = %b | fifo_empty = %b\n \nAsync FIFO (ram_to_p): \n w_en = %b | r_en = %b | reset %b | write_data = %b \nread_data = %b | fifo_full = %b | fifo_empty = %b\n", 
            soc_i.processor_unpipelined.program_counter_address,
            soc_i.processor_unpipelined.instruction, 
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
            soc_i.processor_unpipelined.reg_files.register_file_memory[7],
            soc_i.processor_unpipelined.reg_files.register_file_memory[31],
            soc_i.ram1.memory[0],
            soc_i.ram1.memory[1],
            soc_i.ram1.memory[2],
            soc_i.ram1.memory[3],
            soc_i.ram1.memory[4],
            soc_i.ram1.memory[5],
            soc_i.ram1.memory[6],
            soc_i.ram1.memory[7],
            soc_i.ram1.memory[8],
            soc_i.p_to_ram_fifo.w_en,
            soc_i.p_to_ram_fifo.r_en,
            soc_i.p_to_ram_fifo.reset,
            soc_i.p_to_ram_fifo.write_data,
            soc_i.p_to_ram_fifo.read_data, 
            soc_i.p_to_ram_fifo.fifo_full,
            soc_i.p_to_ram_fifo.fifo_empty,
            soc_i.ram_to_p_fifo.w_en,
            soc_i.ram_to_p_fifo.r_en,
            soc_i.ram_to_p_fifo.reset,
            soc_i.ram_to_p_fifo.write_data,
            soc_i.ram_to_p_fifo.read_data, 
            soc_i.ram_to_p_fifo.fifo_full,
            soc_i.ram_to_p_fifo.fifo_empty
        );
    end 

    // Clock generation
    always #3 p_clk = ~p_clk;

    always #5 ram_clk = ~ram_clk;

endmodule
