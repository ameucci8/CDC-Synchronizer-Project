module full_adder(
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
  
// Intermediate signals
wire a_xor_b, a_and_b, a_xor_b_and_cin;
  
  
// Gate-level logic
xor (a_xor_b, a, b);          // a_xor_b = a ^ b
xor (sum, a_xor_b, cin);      // sum = a_xor_b ^ cin
and (a_and_b, a, b);          // a_and_b = a & b
and (a_xor_b_and_cin, a_xor_b, cin); // a_xor_b_and_cin = a_xor_b & cin
or (cout, a_and_b, a_xor_b_and_cin); // cout = a_and_b | a_xor_b_and_cin

endmodule