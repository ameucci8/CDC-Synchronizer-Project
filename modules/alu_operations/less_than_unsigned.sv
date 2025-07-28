module less_than_unsigned #(
    N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

wire [(N > 0) ? N-1 : 0 : 0] sub_out;

wire [1:0] cases; // 4 cases of the last bits a[n-1], b[n-1] : 0,0 | 0,1 | 1,0 | 1,1
wire [3:0] flag_values;

assign cases[1] = a[(N > 0) ? N-1 : 0 ];
assign cases[0] = b[(N > 0) ? N-1 : 0 ];


subtractor #(
    .N(N)
) subtractor1 (
    .a(a),
    .b(b),
    .cin(1'b1),
    .sum(sub_out),
    .cout(/*nc*/),
    .overflow(/*nc*/)
);

assign flag_values[0] = sub_out[(N > 0) ? N-1 : 0 ]; //takes the sign of the signed subtraction
assign flag_values[1] = 1'b1;  // a[n-1] = 0; b[n-1] = 1; a < b hence 1
assign flag_values[2] = 1'b0;  // a[n-1] = 1; b[n-1] = 0; b > a hence 0 
assign flag_values[3] = sub_out[(N > 0) ? N-1 : 0 ]; //takes the sign of the signed subtraction


mux #(
    .NUM_INPUTS(4)
) u_mux (
    .a(flag_values),
    .sel(cases),
    .out(out[0])
);

genvar i;
generate
    for(i = 1; i < N; i = i + 1) begin
        assign out[i] = 1'b0;
    end
endgenerate

endmodule