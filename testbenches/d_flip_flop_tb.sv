module d_flip_flop_tb;

  // Testbench signals
  reg D;
  reg clk;
  wire Q;
  wire Qn;

  // Instantiate the D flip-flop
  d_flip_flop uut (
    .D(D),
    .clk(clk),
    .Q(Q),
    .Qn(Qn)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 time units
  end

  // Testbench procedure
  initial begin
    // Initialize signals
    D = 0;

    // Apply test vectors
    #10 D = 1; // Set D to 1
    #10 D = 0; // Set D to 0
    #10 D = 1; // Set D to 1
    #10 D = 0; // Set D to 0

    // Finish simulation
    #50 $stop;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %0t | D = %b | clk = %b | Q = %b | Qn = %b", $time, D, clk, Q, Qn);
  end

endmodule
