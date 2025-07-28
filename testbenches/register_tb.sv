module register_tb;

  // Parameter for the width of the register
  parameter N = 8;

  // Testbench signals
  reg clk;
  reg reset;
  reg en;
  reg [N-1:0] D;
  wire [N-1:0] Q;

  // Instantiate the register
  register #(N) uut (
    .clk(clk),
    .reset(reset),
    .enable(en),
    .D(D),
    .Q(Q)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 time units
  end

  // Testbench procedure
  initial begin
    // Initialize signals
    reset = 1;
    en = 0;
    D = 0;

    // Apply test vectors
    #10 reset = 0; en = 1; D = 8'hA5; // Load 0xA5 into the register
    #10 en = 0;                       // Disable loading
    #10 D = 8'h3C;                    // Change data input, but it should not load
    #10 en = 1;                       // Enable loading, register should now load 0x3C
    #10 reset = 1;                    // Reset the register
    #10 reset = 0; en = 1; D = 8'hFF; // Load 0xFF into the register

    // Finish simulation
    #50 $stop;
  end

  // Monitor changes
  initial begin
    $monitor("Time = %0t | reset = %b | clk = %b | enable = %b | D = %h | Q = %h", $time, reset, clk, en, D, Q);
  end

endmodule
