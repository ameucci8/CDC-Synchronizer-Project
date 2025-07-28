module asynchronous_fifo_tb;

    // Parameters
    parameter NUM_ADDRESS = 8;
    parameter DATA_LENGTH = 32;

    // Inputs
    reg w_clk;
    reg r_clk;
    reg w_en;
    reg r_en;
    reg reset;
    reg [DATA_LENGTH-1:0] write_data;

    // Outputs
    wire [DATA_LENGTH-1:0] read_data;
    wire fifo_full;
    wire fifo_empty;

    // Instantiate the Unit Under Test (UUT)
    asynchronous_fifo #(
        .NUM_ADDRESS(NUM_ADDRESS),
        .DATA_LENGTH(DATA_LENGTH)
    ) uut (
        .w_clk(w_clk),
        .r_clk(r_clk),
        .w_en(w_en),
        .r_en(r_en),
        .reset(reset),
        .write_data(write_data),
        .read_data(read_data),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

    // Clock generation
    initial begin
        w_clk = 0;
        forever #5 w_clk = ~w_clk; // 100 MHz clock
    end

    initial begin
        r_clk = 0;
        forever #7 r_clk = ~r_clk; // ~71.4 MHz clock
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        reset = 1;
        w_en = 0;
        r_en = 0;
        write_data = 0;

        // Wait for global reset
        #20;
        reset = 0;

        // Write data to FIFO
        @(negedge w_clk);
        w_en = 1;
        write_data = 32'hA5A5A5A5;
        @(negedge w_clk);
        write_data = 32'hdeadbabe;
        @(negedge w_clk);
        w_en = 0;

        // Read data from FIFO
        @(negedge r_clk);
        r_en = 1;
        @(negedge r_clk);
        @(negedge r_clk);
        r_en = 0;


        // Write data to FIFO
        @(negedge w_clk);
        w_en = 1;
        write_data = 32'hdeadfade;
        @(negedge w_clk);
        write_data = 32'hfaded000;
        @(negedge w_clk);
        w_en = 0;


        // Read data from FIFO
        @(negedge r_clk);
        r_en = 1;
        @(negedge r_clk);
        @(negedge r_clk);
        @(negedge r_clk);
        @(negedge r_clk);
        r_en = 0;


        @(negedge w_clk);
        w_en = 1;
        write_data = 32'hfadefade;
        //filling all of memory with fadefade to test fifo full
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        @(negedge w_clk);
        w_en = 0;

        // Finish simulation
        #10;
        $stop;
    end


    initial begin
        $monitor("INPUTS: \nwrite clock = %b | read clock %b \nreset = %b | write enable = %b | read enable = %b \nwrite data = %h \nINTERNAL SIGNALS: \nwrite address = %b | read address = %b \nmemory[0] = %h | memory[1] = %h | memory[2] = %h | memory[3] = %h \nmemory[4] = %h | memory[5] = %h | memory[6] = %h | memory[7] = %h\nOUTPUTS: \n read data = %h | fifo full = %b | fifo empty = %b \n",
            w_clk,
            r_clk,
            reset,
            w_en,
            r_en,
            write_data,
            uut.write_address,
            uut.read_address,
            uut.fifo_memory.register_file_memory[0],
            uut.fifo_memory.register_file_memory[1],
            uut.fifo_memory.register_file_memory[2],
            uut.fifo_memory.register_file_memory[3],
            uut.fifo_memory.register_file_memory[4],
            uut.fifo_memory.register_file_memory[5],
            uut.fifo_memory.register_file_memory[6],
            uut.fifo_memory.register_file_memory[7],
            read_data,
            fifo_full,
            fifo_empty

        );
    end

endmodule