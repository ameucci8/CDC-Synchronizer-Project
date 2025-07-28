module ram_tb;

    // Parameter
    parameter N = 256;
    parameter ADDR_WIDTH = $clog2(N);

    // Testbench signals
    reg clk;
    reg reset;
    reg read_write;
    reg enable;
    reg [ADDR_WIDTH-1:0] addr;
    reg [31:0] data_in;
    wire [31:0] data_out;

    // Instantiate the RAM module
    ram #(N) uut (
        .clk(clk),
        .reset(reset),
        .read_write(read_write),
        .enable(enable),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        read_write = 0;
        enable = 0;
        addr = 0;
        data_in = 0;
        #10;  // Wait for 10 time units

        // Release reset
        reset = 0;
        #10;

        // Test case 1: Write data to address 0
        read_write = 1;  // Write
        enable = 1;
        addr = 0;
        data_in = 32'hA5A5A5A5;
        #10;
        $display("TEST 1: WRITING DATA: %h, INTO ADDR %h", addr, data_in);
        $display("Test result 1: addr = %h, data_out = %h", addr, data_out);
        $display("Memory: addr = 0, data_out = %h", uut.memory[0]);
        $display("Memory: addr = 1, data_out = %h", uut.memory[1]);
        $display("Memory: addr = 2, data_out = %h", uut.memory[2]);
        $display("Memory: addr = 3, data_out = %h", uut.memory[3]);
        $display("Memory: addr = 4, data_out = %h", uut.memory[4]);
        $display("Memory: addr = 5, data_out = %h", uut.memory[5]);
        $display("Memory: addr = 6, data_out = %h", uut.memory[6]);
        $display("Memory: addr = 7, data_out = %h", uut.memory[7]);
        $display("");
        enable = 0;
        #10;

        // Test case 2: Read data from address 0
        read_write = 0;  // Read
        enable = 1;
        addr = 0;
        #10;

        $display("TEST 2: READING DATA: %h, FROM ADDR %h", addr, data_in);
        $display("Test result 2: addr = %h, data_out = %h", addr, data_out);
        $display("Memory: addr = 0, data_out = %h", uut.memory[0]);
        $display("Memory: addr = 1, data_out = %h", uut.memory[1]);
        $display("Memory: addr = 2, data_out = %h", uut.memory[2]);
        $display("Memory: addr = 3, data_out = %h", uut.memory[3]);
        $display("Memory: addr = 4, data_out = %h", uut.memory[4]);
        $display("Memory: addr = 5, data_out = %h", uut.memory[5]);
        $display("Memory: addr = 6, data_out = %h", uut.memory[6]);
        $display("Memory: addr = 7, data_out = %h", uut.memory[7]);
        $display("");
        enable = 0;
        #10;

        // Test case 3: Write data to address 1
        read_write = 1;  // Write
        enable = 1;
        addr = 1;
        data_in = 32'h5A5A5A5A;
        #10;
        $display("TEST 3: WRITING DATA: %h, INTO ADDR %h", addr, data_in);
        $display("Test result 3: addr = %h, data_out = %h", addr, data_out);
        $display("Memory: addr = 0, data_out = %h", uut.memory[0]);
        $display("Memory: addr = 1, data_out = %h", uut.memory[1]);
        $display("Memory: addr = 2, data_out = %h", uut.memory[2]);
        $display("Memory: addr = 3, data_out = %h", uut.memory[3]);
        $display("Memory: addr = 4, data_out = %h", uut.memory[4]);
        $display("Memory: addr = 5, data_out = %h", uut.memory[5]);
        $display("Memory: addr = 6, data_out = %h", uut.memory[6]);
        $display("Memory: addr = 7, data_out = %h", uut.memory[7]);
        $display("");
        enable = 0;
        #10;

        // Test case 4: Read data from address 1
        read_write = 0;  // Read
        enable = 1;
        addr = 1;
        #10;
        $display("TEST 4: DATA: %h, FROM ADDR %h", addr, data_in);
        $display("Test case 4: addr = %h, data_out = %h", addr, data_out);
        $display("Memory: addr = 0, data_out = %h", uut.memory[0]);
        $display("Memory: addr = 1, data_out = %h", uut.memory[1]);
        $display("Memory: addr = 2, data_out = %h", uut.memory[2]);
        $display("Memory: addr = 3, data_out = %h", uut.memory[3]);
        $display("Memory: addr = 4, data_out = %h", uut.memory[4]);
        $display("Memory: addr = 5, data_out = %h", uut.memory[5]);
        $display("Memory: addr = 6, data_out = %h", uut.memory[6]);
        $display("Memory: addr = 7, data_out = %h", uut.memory[7]);
        $display("");
        enable = 0;
        #10;


        // Finish simulation
        $stop;
    end

endmodule
