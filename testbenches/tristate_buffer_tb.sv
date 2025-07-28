module tristate_buffer_tb;

    // Parameters
    localparam N = 8;

    // Testbench signals
    logic [N-1:0] a;
    logic en;
    logic [N-1:0] out;

    // Instantiate the module under test (MUT)
    tristate_buffer #(N) uut (
        .a(a),
        .en(en),
        .out(out)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        a = 8'b00000000;
        en = 0;

        // Apply test vectors
        #10; a = 8'b11111111; en = 0; // Expect out = 'z'
        #10; a = 8'b10101010; en = 1; // Expect out = 10101010
        #10; a = 8'b01010101; en = 1; // Expect out = 01010101
        #10; a = 8'b11110000; en = 0; // Expect out = 'z'

        // Finish simulation
        #10; $finish;
    end

    // Monitor changes
    initial begin
        $monitor("At time %t: a = %b, en = %b, out = %b", $time, a, en, out);
    end

endmodule
