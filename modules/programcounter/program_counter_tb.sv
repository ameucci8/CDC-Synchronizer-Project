module program_counter_tb;

    // Inputs to the Program Counter
    reg clk;
    reg reset;
    reg pc_write;
    reg [31:0] next_pc;

    // Output from the Program Counter
    wire [31:0] pc;

    // Instantiate the Program Counter
    program_counter uut (
        .clk(clk),
        .reset(reset),
        .pc_write(pc_write),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with a period of 10 time units
    end

    // Test sequence
    initial begin
        // Monitor the signals
        $display("Time\tclk\treset\tpc_write\tnext_pc\tpc");
        $monitor("%4d\t%b\t%b\t%b\t%h\t%h", $time, clk, reset, pc_write, next_pc, pc);

        // Test 1: Reset the PC
        reset = 1;
        pc_write = 0;
        next_pc = 32'h00000000;
        #10 reset = 0;  // De-assert reset

        // Test 2: Write next PC value (next_pc = 32'h00000004)
        pc_write = 1;
        next_pc = 32'h00000004;
        #10;

        // Test 3: Write another PC value (next_pc = 32'h00000008)
        next_pc = 32'h00000008;
        #10;

        // Test 4: Disable write, PC should hold its value
        pc_write = 0;
        next_pc = 32'h00000010;
        #10;

        // Test 5: Write a new PC value after holding
        pc_write = 1;
        next_pc = 32'h00000020;
        #10;

        // Finish simulation
        $finish;
    end

endmodule
