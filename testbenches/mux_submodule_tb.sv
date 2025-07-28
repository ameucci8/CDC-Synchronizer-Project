`timescale 1ns / 1ps

module mux_submodule_tb;

    // Parameters
    parameter NUM_INPUTS = 16;

    // Inputs
    reg [(NUM_INPUTS > 1) ? NUM_INPUTS-1 : 0 : 0] a;
    reg sel;

    // Outputs
    wire [(NUM_INPUTS > 1) ? NUM_INPUTS/2 -1 : 0 : 0] z;

    // Instantiate the Unit Under Test (UUT)
    mux_submodule #(
        .NUM_INPUTS(NUM_INPUTS)
    ) uut (
        .a(a),
        .sel(sel),
        .z(z)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        sel = 0;

        // Wait for global reset
        #100;

        // Apply test vectors
        a = 16'b1010101010101010; sel = 0; #10;
        a = 16'b1010101010101010; sel = 1; #10;
        a = 16'b0101010101010101; sel = 0; #10;
        a = 16'b0101010101010101; sel = 1; #10;

        // Add more test vectors as needed

        // Finish simulation
        #100;
        $stop;
    end

    initial begin
        $monitor("Time = %0t, a = %b, sel = %b, z = %b", $time, a, sel, z);
    end

endmodule
