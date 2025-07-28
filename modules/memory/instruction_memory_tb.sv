module instruction_memory_tb;

    // Inputs to the Instruction Memory
    reg clk;
    reg reset;
    reg [2:0] address;

    // Output from the Instruction Memory
    wire [31:0] instruction;

    // Instantiate the Instruction Memory
    instruction_memory uut (
        .clk(clk),
        .reset(reset),
        .address(address),
        .instruction(instruction)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with a period of 10 time units
    end

    // Test sequence
    initial begin
        // Monitor the outputs
        $monitor("Time: %d, Address: %b, Instruction: %h", $time, address, instruction);

        // Initialize inputs
        reset = 1;
        #10 reset = 0;

        // Test 1: Fetch instruction at address 0
        address = 3'b000;
        #10;

        // Test 2: Fetch instruction at address 1
        address = 3'b001;
        #10;

        // Test 3: Fetch instruction at address 2
        address = 3'b010;
        #10;

        // Test 4: Fetch instruction at address 3
        address = 3'b011;
        #10;

        // Finish simulation
        $finish;
    end

endmodule
