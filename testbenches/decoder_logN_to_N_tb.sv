module decoder_logN_to_N_tb;

    // Parameters
    parameter N = 8;
    localparam ADDR_WIDTH = (N > 0) ? $clog2(N) : 1;

    // Inputs
    reg [ADDR_WIDTH-1:0] address;
    reg enable;

    // Outputs
    wire [N-1:0] out;

    // Instantiate the Unit Under Test (UUT)
    decoder_logN_to_N #(
        .N(N)
    ) uut (
        .address(address),
        .enable(enable),
        .out(out)
    );

    initial begin
        // Initialize Inputs
        address = 0;
        enable = 0;

        // Wait for global reset
        #100;

        // Test sequence
        enable = 1;
        for (integer i = 0; i < N; i = i + 1) begin
            address = i;
            #10;
        end

        // Disable the decoder
        enable = 0;
        #10;

        // Finish simulation
        $finish;
    end

    initial begin
        // Monitor changes
        $monitor("Time = %0t, Address = %0d, Enable = %b, Out = %b", $time, address, enable, out);
    end

endmodule
