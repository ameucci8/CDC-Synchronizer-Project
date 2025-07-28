module or_n_to_1_tb;

    // Parameters
    parameter NUM_INPUTS = 8;

    // Testbench signals
    reg [NUM_INPUTS-1:0] a;
    wire out;

    // Instantiate the module under test (MUT)
    or_n_to_1 #(
        .NUM_INPUTS(NUM_INPUTS)
    ) uut (
        .a(a),
        .out(out)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        a = 8'b0;

        // Apply test vectors
        #10 a = 8'b00000001; // Test case 1
        #10 a = 8'b00000010; // Test case 2
        #10 a = 8'b00000100; // Test case 3
        #10 a = 8'b00001000; // Test case 4
        #10 a = 8'b00010010; // Test case 5
        #10 a = 8'b00101100; // Test case 6
        #10 a = 8'b01000000; // Test case 7
        #10 a = 8'b10000000; // Test case 8
        #10 a = 8'b11111111; // Test case 9

        // Finish simulation
        #10 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t, a = %b, out = %b", $time, a, out);
    end

endmodule
