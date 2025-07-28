module tristate_buffer_1_bit_tb;

    // Declare testbench variables
    logic a;
    logic en;
    logic out;

    // Instantiate the module under test (MUT)
    tristate_buffer_1_bit uut (
        .a(a),
        .en(en),
        .out(out)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        a = 0;
        en = 0;

        // Apply test vectors
        #10; a = 1; en = 0; // Expect out = 'z'
        #10; a = 0; en = 1; // Expect out = 0
        #10; a = 1; en = 1; // Expect out = 1
        #10; a = 0; en = 0; // Expect out = 'z'

        // Finish simulation
        #10; $finish;
    end

    // Monitor changes
    initial begin
        $monitor("At time %t: a = %b, en = %b, out = %b", $time, a, en, out);
    end

endmodule
