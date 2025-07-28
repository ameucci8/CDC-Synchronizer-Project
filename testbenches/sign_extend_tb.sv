module sign_extend_tb;

    // Parameters
    parameter NUM_INPUTS = 16;
    parameter NUM_OUTPUTS = 32;

    // Inputs
    reg [NUM_INPUTS-1:0] a;

    // Outputs
    wire [NUM_OUTPUTS-1:0] z;

    // Instantiate the Unit Under Test (UUT)
    sign_extend #(
        .NUM_INPUTS(NUM_INPUTS),
        .NUM_OUTPUTS(NUM_OUTPUTS)
    ) uut (
        .a(a),
        .z(z)
    );

    initial begin
        // Initialize Inputs
        a = 16'b0000_0000_0000_0001; // Example input

        // Wait for some time to observe the output
        #10;
        
        // Change input and observe output
        a = 16'b1000_0000_0000_0000; // Example input with sign bit set

        // Wait for some time to observe the output
        #10;

         // Initialize Inputs
        a = 16'b0000_1100_0000_0001; // Example input

        // Wait for some time to observe the output
        #10;
        
        // Change input and observe output
        a = 16'b1010_0100_1100_0000; // Example input with sign bit set

        // Wait for some time to observe the output
        #10;

        // Finish simulation
        $stop;
    end

    initial begin
        // Monitor changes
        $monitor("Time = %0t, a = %b, z = %b", $time, a, z);
    end

endmodule
