module nand_op #(
    N = 8
)(
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

genvar i;
generate
    for(i = 0; i < N; i = i + 1) begin
        nand(out[i], a[i], b[i]);
    end
endgenerate


endmodule