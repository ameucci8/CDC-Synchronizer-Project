module shift_right_op_tb;

  // Parameter
  parameter N = 8;

  // Testbench signals
  reg [(N > 0) ? N-1 : 0 : 0] a;
  reg [(N > 0) ? N-1 : 0 : 0] b;
  wire [(N > 0) ? N-1 : 0 : 0] out;

  // Instantiate the DUT (Device Under Test)
  shift_right_op #(N) dut (
    .a(a),
    .b(b),
    .out(out)
  );

  initial begin
    // Initialize inputs
    a = 8'b10000001;
    b = 8'b00000010;

    // Wait for some time and observe the output
    #10;
    $display("a = %b, b = %b, out = %b", a, b, out);

    // Change inputs
    a = 8'b01001011;
    b = 8'b00000100;

    // Wait for some time and observe the output
    #10;
    $display("a = %b, b = %b, out = %b", a, b, out);


  // Change inputs
    a = 8'b01001011;
    b = 8'b01000100;

    // Wait for some time and observe the output
    #10;
    $display("a = %b, b = %b, out = %b", a, b, out);

    // Finish simulation
    #10;
    $stop;
  end

endmodule
