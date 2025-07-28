module comparison_flags #(
    N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    //output wire greater_than_flag,
    //output wire less_than_flag,
    output wire equal_to_flag
);

wire [(N > 0) ? N-1 : 0 : 0] eq;

xor_op #(
    .N(N)
) uut (
    .a(a),
    .b(b),
    .out(eq)
);

or_n_to_1 #(
    .N(N)
) uut1 (
    .a(eq),
    .out(equal_to_flag)
);




/*
subtractor #(
    .N(N)
) subtractor1 (
    .a(a),
    .b(b),
    .cin(1'b1),
    .sum(),
    .cout()
)



wire 
wire [(N-1) ? N-1 : 0 : 0] sub_out;

genvar i;
generate

subtractor1

endgenerate

*/
endmodule