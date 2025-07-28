module decoder_submodule #(
    N = 8
) (
    input wire address,
    input wire [(N > 0) ? N-1 : 0 : 0] enable,
    output wire [(N > 0) ? 2*N -1 : 0 : 0] out
);

genvar i;
generate 

for(i = 0; i < N; i = i + 1) begin
    decoder_1_to_2 decoder_1_to_2_u (
        .address(address),
        .enable(enable[i]),
        .out(out[2*i + 1 : 2*i])
    );
end

endgenerate


endmodule