module decoder_logN_to_N #(
    N = 8
) (
    input wire [(N > 0) ? $clog2(N)-1 : 0 : 0] address,
    input wire enable,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

wire [(N > 0) ? 2*N - 2 : 0 : 0] decode_out;
assign decode_out[0] = enable;

genvar i;
generate

for(i = 1; i < N; i = i * 2) begin
    decoder_submodule #(
        .N(i)
    ) uut1 (
        .address(address[$clog2(N/i) - 1]),
        .enable(decode_out[2*i - 2 : i - 1]),
        .out(decode_out[4*i - 2 : 2*i - 1])
    );
end
endgenerate

assign out = decode_out[2*N - 2 : N - 1];

endmodule