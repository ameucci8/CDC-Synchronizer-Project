module register_32bit_tb;

    // Inputs to the 32-bit register
    reg clk;
    reg reset;
    reg enable;
    reg [31:0] d_in;

    // Output from the 32-bit register
    wire [31:0] q_out;

    // Instantiate the 32-bit register
    register_32bit uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .d_in(d_in),
        .q_out(q_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with a period of 10 time units
    end

    // Test sequence
    initial begin
        // Monitor signals
        $display("Time\tclk\treset\tenable\td_in\tq_out");
        $monitor("%4d\t%b\t%b\t%b\t%h\t%h", $time, clk, reset, enable, d_in, q_out);

        // Initialize inputs
        reset = 1;
        enable = 0;
        d_in = 32'h00000000;

        // Test 1: Reset the register (q_out should be 0)
        #10 reset = 0;  // De-assert reset

        // Test 2: Enable the register and write a value (d_in = 32'hAAAAAAAA)
        #10 enable = 1;
        d_in = 32'hAAAAAAAA;
        #10;

        // Test 3: Change d_in but disable writing (q_out should hold previous value)
        enable = 0;
        d_in = 32'h55555555;
        #10;

        // Test 4: Enable the register again and write a new value (d_in = 32'h12345678)
        enable = 1;
        d_in = 32'h12345678;
        #10;

        // Finish simulation
        $finish;
    end

endmodule