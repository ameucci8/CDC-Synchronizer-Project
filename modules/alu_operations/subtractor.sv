module subtractor #(
    parameter N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    input wire cin,
    output wire [(N > 0) ? N-1 : 0 : 0] sum,
    output wire cout,
    output wire overflow
);

wire [(N > 0) ? N-1 : 0 : 0] b_inv;

genvar i; 
generate
    for(i = 0; i < N; i = i + 1) begin
        not (b_inv[i], b[i]);
    end 
endgenerate

adder_n_bit #(
    .N(N)
) adder1 (
    .a(a),
    .b(b_inv),
    .cin(cin),
    .sum(sum),
    .cout(cout),
    .overflow(overflow)
);



endmodule