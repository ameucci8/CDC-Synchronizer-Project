`timescale 1ns / 1ps

module mux_tb;

    // Parameters
    parameter NUM_INPUTS = 8;

    // Inputs
    reg [NUM_INPUTS-1:0] a;
    reg [$clog2(NUM_INPUTS)-1:0] sel;

    // Outputs
    wire out;

    // Instantiate the Unit Under Test (UUT)
    mux #(
        .NUM_INPUTS(NUM_INPUTS)
    ) uut (
        .a(a),
        .sel(sel),
        .out(out)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        sel = 0;

        // Wait for global reset
        #100;

                // Apply test vectors
        a = 8'b10101010; sel = 3'b000; #10;
        a = 8'b10101010; sel = 3'b001; #10;
        a = 8'b10101010; sel = 3'b010; #10;
        a = 8'b10101010; sel = 3'b011; #10;
        a = 8'b10101010; sel = 3'b100; #10;
        a = 8'b10101010; sel = 3'b101; #10;
        a = 8'b10101010; sel = 3'b110; #10;
        a = 8'b10101010; sel = 3'b111; #10;

        a = 8'b11001100; sel = 3'b000; #10;
        a = 8'b11001100; sel = 3'b001; #10;
        a = 8'b11001100; sel = 3'b010; #10;
        a = 8'b11001100; sel = 3'b011; #10;
        a = 8'b11001100; sel = 3'b100; #10;
        a = 8'b11001100; sel = 3'b101; #10;
        a = 8'b11001100; sel = 3'b110; #10;
        a = 8'b11001100; sel = 3'b111; #10;

        a = 8'b11110000; sel = 3'b000; #10;
        a = 8'b11110000; sel = 3'b001; #10;
        a = 8'b11110000; sel = 3'b010; #10;
        a = 8'b11110000; sel = 3'b011; #10;
        a = 8'b11110000; sel = 3'b100; #10;
        a = 8'b11110000; sel = 3'b101; #10;
        a = 8'b11110000; sel = 3'b110; #10;
        a = 8'b11110000; sel = 3'b111; #10;

        a = 8'b00001111; sel = 3'b000; #10;
        a = 8'b00001111; sel = 3'b001; #10;
        a = 8'b00001111; sel = 3'b010; #10;
        a = 8'b00001111; sel = 3'b011; #10;
        a = 8'b00001111; sel = 3'b100; #10;
        a = 8'b00001111; sel = 3'b101; #10;
        a = 8'b00001111; sel = 3'b110; #10;
        a = 8'b00001111; sel = 3'b111; #10;

        a = 8'b11111111; sel = 3'b000; #10;
        a = 8'b11111111; sel = 3'b001; #10;
        a = 8'b11111111; sel = 3'b010; #10;
        a = 8'b11111111; sel = 3'b011; #10;
        a = 8'b11111111; sel = 3'b100; #10;
        a = 8'b11111111; sel = 3'b101; #10;
        a = 8'b11111111; sel = 3'b110; #10;
        a = 8'b11111111; sel = 3'b111; #10;

        a = 8'b00000000; sel = 3'b000; #10;
        a = 8'b00000000; sel = 3'b001; #10;
        a = 8'b00000000; sel = 3'b010; #10;
        a = 8'b00000000; sel = 3'b011; #10;
        a = 8'b00000000; sel = 3'b100; #10;
        a = 8'b00000000; sel = 3'b101; #10;
        a = 8'b00000000; sel = 3'b110; #10;
        a = 8'b00000000; sel = 3'b111; #10;


        // Add more test vectors as needed

        // Finish simulation
        #100;
        $stop;
    end

    initial begin
        $monitor("Time = %0t, a = %b, sel = %b, out = %b, mux_out = %b", $time, a, sel, out, uut.mux_out);
    end

endmodule
