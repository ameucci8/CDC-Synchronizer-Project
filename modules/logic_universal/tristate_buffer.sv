module tristate_buffer #(
    N = 8
) (
    input  wire [(N > 0) ? N-1 : 0 : 0] a,
    input  wire en,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);


genvar i;
generate
for(i = 0; i < N; i = i +1) begin
    tristate_buffer_1_bit tristate_buffer_1 (
        .a(a[i]),
        .en(en),
        .out(out[i])
    );
end
endgenerate

endmodule