module fifo_write_pointer_full_tb;

  // Parameters
  parameter NUM_ADDRESS = 8;
  localparam ADDR_WIDTH = $clog2(NUM_ADDRESS);

  // Inputs
  reg write_clk;
  reg write_enable;
  reg write_reset;
  reg [ADDR_WIDTH:0] read_pointer_sync;

  // Outputs
  wire [ADDR_WIDTH:0] write_pointer;
  wire [ADDR_WIDTH-1:0] write_address;
  wire fifo_full;

  // Instantiate the Unit Under Test (UUT)
  fifo_write_pointer_full #(
    .NUM_ADDRESS(NUM_ADDRESS)
  ) uut (
    .write_clk(write_clk),
    .write_enable(write_enable),
    .write_reset(write_reset),
    .read_pointer_sync(read_pointer_sync),
    .write_pointer(write_pointer),
    .write_address(write_address),
    .fifo_full(fifo_full)
  );

  // Clock generation
  always #5 write_clk = ~write_clk;

  // Test sequence
  initial begin
    // Initialize Inputs
    write_clk = 0;
    write_enable = 0;
    write_reset = 1;
    read_pointer_sync = 0;

    // Wait for global reset
    #10;
    write_reset = 0;

    // Write some data
    write_enable = 1;
    #100; //wait 100 ns for FIFO to fill 

    // Disable write
    read_pointer_sync = 4'b0101; // 6 in decimal from gray code
    #100;

    // Finish simulation
    $stop;
  end


  initial begin 
    $monitor("INPUTS: clk = %b | enable = %b | reset = %b | read pointer(gray) = %b\nOUTPUTS: write pointer (gray) %b | write adress = %b | full %b \nINTERNAL: read addr comp = %b | write addr comp = %b \n", 
            write_clk, 
            write_enable,
            write_reset,
            read_pointer_sync,
            write_pointer,
            write_address,
            fifo_full,
            uut.read_address,
            uut.write_address_all_bits
        );
  end
    

endmodule