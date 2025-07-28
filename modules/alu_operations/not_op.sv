module not_op #(
    N = 8
)(
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

genvar i;
generate
    for(i = 0; i < N; i = i + 1) begin
        not (out[i], a[i]);
    end
endgenerate


endmodule