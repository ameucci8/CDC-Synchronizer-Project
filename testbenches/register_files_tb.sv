`timescale 1ns / 1ps

module register_files_tb;

    // Parameters
    parameter NUM_ADDRESS = 16;
    parameter DATA_LENGTH = 32;

    // Inputs
    reg clk;
    reg reset;
    reg write_enable;
    reg [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] read_address_1;
    reg [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] read_address_2;
    reg [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] write_address;
    reg [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0] write_data_in;

    // Outputs
    wire [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0] read_data_out_1;
    wire [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0] read_data_out_2;

    // Instantiate the Unit Under Test (UUT)
    register_files #(
        .NUM_ADDRESS(NUM_ADDRESS),
        .DATA_LENGTH(DATA_LENGTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .read_address_1(read_address_1),
        .read_address_2(read_address_2),
        .write_address(write_address),
        .write_data_in(write_data_in),
        .read_data_out_1(read_data_out_1),
        .read_data_out_2(read_data_out_2)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 0;
        write_enable = 0;
        read_address_1 = 0;
        read_address_2 = 0;
        write_address = 0;
        write_data_in = 0;

        // Apply reset
        reset = 1;
        #10;
        reset = 0;

        // Write some data
        write_enable = 1;
        write_address = 3;
        write_data_in = 32'hDEADBEEF;
        #10;
        write_enable = 0;

        // Read the data back
        read_address_1 = 3;
        read_address_2 = 3;
        #10;

        // Read the data back
        read_address_1 = 1;
        read_address_2 = 3;
        #10;

        // Read the data back
        read_address_1 = 3;
        read_address_2 = 5;
        #10;

        // Write some data
        write_enable = 1;
        write_address = 6;
        write_data_in = 32'hDEADBABE;
        #10;
        write_enable = 0;

        // Read the data back
        read_address_1 = 6;
        read_address_2 = 3;
        #10;


        // Finish simulation
        $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $monitor("Time = %0t, read_address_1 = %0d, read_data_out_1 = %0h, read_address_2 = %0d, read_data_out_2 = %0h", 
                 $time, read_address_1, read_data_out_1, read_address_2, read_data_out_2);
    end

endmodule
