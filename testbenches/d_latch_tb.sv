module d_latch_tb;

  // Parameter for the width of the data bus
  parameter N = 8;

  // Declare testbench variables
  reg [N-1:0] data;
  reg enable;
  wire [N-1:0] Q;
  wire [N-1:0] Qn;

  // Instantiate the d_latch module
  d_latch #(N) uut (
    .data(data),
    .enable(enable),
    .Q(Q),
    .Qn(Qn)
  );

  // Testbench procedure
  initial begin
    // Initialize inputs
    data = 0;
    enable = 0;

    // Apply test vectors
    #10 data = 8'b10101010; enable = 1;  // Write data to the latch
    #10 enable = 0;                      // Hold state
    #10 data = 8'b01010101; enable = 1;  // Write new data to the latch
    #10 enable = 0;                      // Hold state
    #10 data = 8'b11110000; enable = 1;  // Write another data to the latch
    #10 enable = 0;                      // Hold state

    // Finish simulation
    #10 $finish;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %0t | data = %b | enable = %b | Q = %b | Qn = %b", $time, data, enable, Q, Qn);
  end

endmodule

