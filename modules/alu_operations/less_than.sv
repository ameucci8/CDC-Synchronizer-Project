module less_than #(
    N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

wire flag;
wire options3;
wire [1:0] cases;
wire [3:0] options;
wire options0;
wire [(N > 0) ? N-1 : 0 : 0] zero;
wire [(N > 0) ? N-1 : 0 : 0] less_than_unsigned_out;

less_than_unsigned #(
    .N(N)
) uut11 (
    .a(a),
    .b(b),
    .out(less_than_unsigned_out)
);


assign options0 = less_than_unsigned_out[0];

assign out[N-1 : 1] = less_than_unsigned_out[N-1 : 1];
assign out[0] = flag;

not (options3, options0);

assign cases[1] = a[(N > 0) ? N-1 : 0];
assign cases[0] = b[(N > 0) ? N-1 : 0];

assign options[3] = options3;             //11 (both negative)
assign options[2] = a[(N > 0) ? N-1 : 0]; //10 (a is negative and b is positive)
assign options[1] = a[(N > 0) ? N-1 : 0]; //01 (a is positive and b is negative)
assign options[0] = options0;             //00 (both positive)

mux #(
    .NUM_INPUTS(4)
) u_mux (
    .a(options),
    .sel(cases),
    .out(flag)
);

assign out[0] = flag;

endmodule
