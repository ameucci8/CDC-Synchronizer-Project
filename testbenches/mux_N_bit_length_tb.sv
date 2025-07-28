`timescale 1ns / 1ps

module mux_N_bit_length_tb;

    // Parameters
    parameter NUM_INPUTS = 8;
    parameter NUM_BITS = 32;

    // Inputs
    reg [(NUM_BITS > 0) ? NUM_BITS -1 : 0 : 0] a[NUM_INPUTS-1:0];
    reg [(NUM_INPUTS > 0) ? $clog2(NUM_INPUTS)-1 : 0 : 0] sel;

    // Outputs
    wire [(NUM_BITS > 0) ? NUM_BITS -1 : 0 : 0] out;

    // Instantiate the Unit Under Test (UUT)
    mux_N_bit_length #(
        .NUM_INPUTS(NUM_INPUTS),
        .NUM_BITS(NUM_BITS)
    ) uut (
        .a(a),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Initialize Inputs
        a[0] = 32'd2;
        a[1] = 32'd4;
        a[2] = 32'd8;
        a[3] = 32'd16;
        a[4] = 32'd32;
        a[5] = 32'd33;
        a[6] = 32'd34;
        a[7] = 32'd35;

        #10;

        sel = 3'b000;

        #10;

        sel = 3'b001;

        #10;

        sel = 3'b010;

        #10;

        sel = 3'b011;

        #10;

        sel = 3'b100;

        #10;

        sel = 3'b101;

        #10;

        sel = 3'b110;

        #10;

        sel = 3'b111;

        // Finish simulation
        $finish;
    end

    initial begin
        $monitor("Time = %0t, sel = %0d, out = %0h", $time, sel, out);
    end

endmodule
