module mux_16_to_1_tb;

    // Parameters
    parameter NUM_INPUT_BITS = 8;

    // Inputs
    reg [NUM_INPUT_BITS-1:0] a;
    reg [NUM_INPUT_BITS-1:0] b;
    reg [NUM_INPUT_BITS-1:0] c;
    reg [NUM_INPUT_BITS-1:0] d;
    reg [NUM_INPUT_BITS-1:0] e;
    reg [NUM_INPUT_BITS-1:0] f;
    reg [NUM_INPUT_BITS-1:0] g;
    reg [NUM_INPUT_BITS-1:0] h;
    reg [NUM_INPUT_BITS-1:0] i;
    reg [NUM_INPUT_BITS-1:0] j;
    reg [NUM_INPUT_BITS-1:0] k;
    reg [NUM_INPUT_BITS-1:0] l;
    reg [NUM_INPUT_BITS-1:0] m;
    reg [NUM_INPUT_BITS-1:0] n;
    reg [NUM_INPUT_BITS-1:0] o;
    reg [NUM_INPUT_BITS-1:0] p;
    reg [3:0] sel;

    // Output
    wire [NUM_INPUT_BITS-1:0] z;

    // Instantiate the Unit Under Test (UUT)
    mux_16_to_1 #(
        .INPUT_BIT_LENGTH(NUM_INPUT_BITS)
    ) uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .j(j),
        .k(k),
        .l(l),
        .m(m),
        .n(n),
        .o(o),
        .p(p),
        .sel(sel),
        .z(z)
    );

    initial begin
        // Initialize Inputs
        a = 8'h01;
        b = 8'h02;
        c = 8'h03;
        d = 8'h04;
        e = 8'h05;
        f = 8'h06;
        g = 8'h07;
        h = 8'h08;
        i = 8'h09;
        j = 8'h0A;
        k = 8'h0B;
        l = 8'h0C;
        m = 8'h0D;
        n = 8'h0E;
        o = 8'h0F;
        p = 8'h10;
        sel = 4'b0000;

        // Wait for global reset
        #100;

        // Apply test vectors
        sel = 4'b0000; #10;

        $display("out = %b", z);

        sel = 4'b0001; #10;

        $display("out = %b", z);

        sel = 4'b0010; #10;

        $display("out = %b", z);

        sel = 4'b0011; #10;

        $display("out = %b", z);

        sel = 4'b0100; #10;

        $display("out = %b", z);

        sel = 4'b0101; #10;

        $display("out = %b", z);

        sel = 4'b0110; #10;

        $display("out = %b", z);
        

        sel = 4'b0111; #10;
        sel = 4'b1000; #10;
        sel = 4'b1001; #10;
        sel = 4'b1010; #10;
        sel = 4'b1011; #10;
        sel = 4'b1100; #10;
        sel = 4'b1101; #10;
        sel = 4'b1110; #10;
        sel = 4'b1111; #10;

        // Finish simulation
        $finish;
    end

endmodule
