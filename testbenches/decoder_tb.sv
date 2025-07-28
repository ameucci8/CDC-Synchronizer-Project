module decoder_tb;

    // Parameters for the decoder (you can modify N to test different decoder sizes)
    parameter N = 3;  // For example, 3-to-8 decoder (you can adjust this for different sizes)
    
    // Input and output signals for the decoder
    reg [N-1:0] a;                      // N-bit input
    wire [(2**N)-1:0] y;                // 2^N outputs
    
    // Instantiate the parameterized decoder
    decoder #(.N(N)) uut (
        .a(a),                          // Connect the input 'a' to the decoder
        .y(y)                           // Connect the outputs 'y' to the decoder
    );
    
    // Test procedure
    initial begin
        // Initialize input to 0
        a = 0;
        
        // Display the header for the waveform
        $display("Time\tInput a\tOutput y");
        $monitor("%4d\t%b\t%b", $time, a, y);
        
        // Apply test cases
        #5  a = 3'b000;  // Input 000 -> expect y[0] = 1, others = 0
        #5  a = 3'b001;  // Input 001 -> expect y[1] = 1, others = 0
        #5  a = 3'b010;  // Input 010 -> expect y[2] = 1, others = 0
        #5  a = 3'b011;  // Input 011 -> expect y[3] = 1, others = 0
        #5  a = 3'b100;  // Input 100 -> expect y[4] = 1, others = 0
        #5  a = 3'b101;  // Input 101 -> expect y[5] = 1, others = 0
        #5  a = 3'b110;  // Input 110 -> expect y[6] = 1, others = 0
        #5  a = 3'b111;  // Input 111 -> expect y[7] = 1, others = 0
        
        // Finish the simulation after all cases are tested
        #10 $finish;
    end
    
endmodule