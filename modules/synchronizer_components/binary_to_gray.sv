module binary_to_gray #(
    N = 8
) (
    input wire [(N > 0) ? N - 1 : 0 : 0] binary,
    output wire [(N > 0) ? N - 1 : 0 : 0] gray
);

assign gray[N-1] = binary[N-1];

genvar i;
generate
    for(i = N-1; i > 0; i = i - 1)begin
        xor (gray[i-1], binary[i], binary[i-1]);
    end
endgenerate


endmodule
