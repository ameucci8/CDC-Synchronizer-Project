module mux_4_to_1_tb;

    // Parameters
    parameter INPUT_BIT_LENGTH = 1;

    // Testbench signals
    reg [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] a;
    reg [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] b;
    reg [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] c;
    reg [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] d;
    reg [1:0] sel;
    wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] z;

    // Instantiate the module under test
    mux_4_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    ) uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .z(z)
    );

    // Testbench procedure
    initial begin
        // Initialize inputs
        a = 1'b0;
        b = 1'b0;
        c = 1'b0;
        d = 1'b0;
        sel = 2'b00;

        // Apply test vectors
        #10 a = 1'b1; b = 1'b0; c = 1'b0; d = 1'b1;
        #10 sel = 2'b01;
        #10 sel = 2'b10;
        #10 sel = 2'b11;

        // Finish simulation
        #10 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0t | a = %b | b = %b | c = %b | d = %b | sel = %b | z = %b", $time, a, b, c, d, sel, z);
    end

endmodule
