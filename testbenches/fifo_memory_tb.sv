module fifo_memory_tb;

  // Parameters
  parameter NUM_ADDRESS = 8;
  parameter DATA_LENGTH = 32;
  localparam ADDR_WIDTH = $clog2(NUM_ADDRESS);

  // Inputs
  reg w_clk;
  reg r_clk;
  reg reset;
  reg write_enable;
  reg read_enable;
  reg [ADDR_WIDTH-1:0] read_address;
  reg [ADDR_WIDTH-1:0] write_address;
  reg [DATA_LENGTH-1:0] write_data_in;

  // Outputs
  wire [DATA_LENGTH-1:0] read_data_out;

  // Instantiate the Unit Under Test (UUT)
  fifo_memory #(
    .NUM_ADDRESS(NUM_ADDRESS),
    .DATA_LENGTH(DATA_LENGTH)
  ) uut (
    .w_clk(w_clk),
    .r_clk(r_clk),
    .reset(reset),
    .write_enable(write_enable),
    .read_enable(read_enable),
    .read_address(read_address),
    .write_address(write_address),
    .write_data_in(write_data_in),
    .read_data_out(read_data_out)
  );

  // Clock generation for write clock
  always #5 w_clk = ~w_clk;

  // Clock generation for read clock
  always #7 r_clk = ~r_clk;

  // Test sequence
  initial begin
    // Initialize Inputs
    w_clk = 0;
    r_clk = 0;
    reset = 1;
    write_enable = 0;
    read_enable = 0;
    read_address = 0;
    write_address = 0;
    write_data_in = 0;

    // Wait for global reset
    #10;
    reset = 0;

    // Write some data
    write_enable = 1;
    write_address = 0;
    write_data_in = 32'hA5A5A5A5;
    #10;
    write_address = 1;
    write_data_in = 32'hDEADBABE;
    #10;
    write_enable = 0;

    // Read the data
    read_enable = 1;
    read_address = 0;
    #14; // Wait for read clock edge
    read_address = 1;
    #14;
    read_enable = 0;

    // Finish simulation
    #20;
    $stop;
  end

  initial begin
    $monitor("write clock = %b | read clock %b \nreset = %b | write enable = %b | read enable = %b \nwrite address = %b | read address = %b \nwrite data in = %h | read data out = %h \nmemory[0] = %h | memory[1] = %h | memory [2] = %h \n",
        w_clk,
        r_clk,
        reset,
        write_enable,
        read_enable,
        write_address,
        read_address,
        write_data_in,
        read_data_out,
        uut.register_file_memory[0],
        uut.register_file_memory[1],
        uut.register_file_memory[2]
    );
  end

endmodule