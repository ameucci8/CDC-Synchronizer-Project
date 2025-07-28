module subtractor_tb;

    parameter N = 3;

    // Testbench signals
    logic [N-1:0] a, b;    // Inputs to the full adder
    logic cin;             // Carry-in input
    logic [N-1:0] sum;     // Sum output from the full adder
    logic cout;            // Carry-out output from the full adder

    // Instantiate the full adder module
    subtractor #(
        .N(N)
    ) uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // Testbench procedure
    initial begin
        // Display header
        $display("Time\t a b cin | sum cout");
        $display("-------------------------");

        // Apply test vectors
        a = 3'b000; b = 3'b000; cin = 1'b1; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b000; b = 3'b000; cin = 1'b1; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b000; b = 3'b001; cin = 1'b1; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b010; b = 3'b001; cin = 1'b1; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b001; b = 3'b100; cin = 1'b0; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b101; b = 3'b000; cin = 1'b1; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b001; b = 3'b111; cin = 1'b0; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b101; b = 3'b001; cin = 1'b1; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        a = 3'b101; b = 3'b101; cin = 1'b1; #10;
        $display("%0t\t %b %b %b | %b %b", $time, a, b, cin, sum, cout);

        // End simulation
        $stop;
    end

endmodule
