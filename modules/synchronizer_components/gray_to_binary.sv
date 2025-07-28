module gray_to_binary #(
    N = 8
) (
    input wire [(N > 0) ? N - 1 : 0 : 0] gray,
    output wire [(N > 0) ? N - 1 : 0 : 0] binary
);

assign binary[N-1] = gray[N-1];

genvar i;
generate
    for(i = N-1; i > 0; i = i - 1)begin
        xor (binary[i-1], binary[i], gray[i-1]);
    end
endgenerate


endmodule
