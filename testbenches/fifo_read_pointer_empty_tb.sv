module fifo_read_pointer_empty_tb;

  // Parameters
  parameter NUM_ADDRESS = 8;
  localparam ADDR_WIDTH = $clog2(NUM_ADDRESS);
  localparam POINTER_LENGTH = ADDR_WIDTH + 1;

  // Inputs
  reg read_clk;
  reg read_enable;
  reg read_reset;
  reg [POINTER_LENGTH-1:0] write_pointer_sync;

  // Outputs
  wire [POINTER_LENGTH-1:0] read_pointer;
  wire [ADDR_WIDTH-1:0] read_address;
  wire fifo_empty;

  // Instantiate the Unit Under Test (UUT)
  fifo_read_pointer_empty #(
    .NUM_ADDRESS(NUM_ADDRESS)
  ) uut (
    .read_clk(read_clk),
    .read_enable(read_enable),
    .read_reset(read_reset),
    .write_pointer_sync(write_pointer_sync),
    .read_pointer(read_pointer),
    .read_address(read_address),
    .fifo_empty(fifo_empty)
  );

  // Clock generation
  always #5 read_clk = ~read_clk;

  // Test sequence
  initial begin
    // Initialize Inputs
    read_clk = 0;
    read_enable = 0;
    read_reset = 1;
    write_pointer_sync = 0;

    // Wait for global reset
    #10;
    read_reset = 0;

    // Enable read
    read_enable = 1;
    write_pointer_sync = 4'b0111; // 5 in decimal
    
    #100;

    // Disable read
    read_enable = 0;
    #20;

    // Finish simulation
    $stop;
  end


initial begin 
    $monitor("INPUTS: clk = %b | enable = %b | reset = %b | write pointer(gray) = %b\nOUTPUTS: read pointer (gray) %b | read address = %b | empty %b \n", 
            read_clk, 
            read_enable,
            read_reset,
            write_pointer_sync,
            read_pointer,
            read_address,
            fifo_empty
        );
  end
endmodule