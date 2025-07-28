module tb_overflow;

  // Testbench signals
  reg a, b, c;
  wire z;

  // Instantiate the overflow module
  overflow uut (
    .a(a),
    .b(b),
    .z(c),
    .overflow(z)
  );

  // Testbench logic
  initial begin
    // Display header
    $display("Time\t a b c | z");
    $display("-------------------");

    // Apply test vectors
    a = 0; b = 0; c = 0; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    a = 0; b = 1; c = 0; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    a = 1; b = 0; c = 0; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    a = 1; b = 1; c = 0; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    a = 0; b = 0; c = 1; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    a = 0; b = 1; c = 1; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    a = 1; b = 0; c = 1; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    a = 1; b = 1; c = 1; #10;
    $display("%0t\t %b %b %b | %b", $time, a, b, c, z);

    // Finish simulation
    $finish;
  end

endmodule

