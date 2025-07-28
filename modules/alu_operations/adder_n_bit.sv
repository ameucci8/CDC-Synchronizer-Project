module adder_n_bit #(
    parameter N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    input wire cin,
    output wire [(N > 0) ? N-1 : 0 : 0] sum,
    output wire cout,
    output wire overflow
);

overflow uut1 (
    .a(a[N-1]), 
    .b(b[N-1]), 
    .z(sum[N-1]), 
    .overflow(overflow)
);


genvar i;
generate
    if( N > 1) begin 

        wire carry[N:0];

        assign carry[0] = cin;
        assign cout = carry[N];

        for(i = 0; i < N; i = i + 1) begin : gen_multiple_cells
            full_adder uut (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    end else begin
        full_adder uut2 (
            .a(a),
            .b(b),
            .cin(cin),
            .sum(sum),
            .cout(cout)
        );
    end
endgenerate

endmodule
