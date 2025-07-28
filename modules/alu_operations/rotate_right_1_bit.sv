module rotate_right_1_bit #(
    N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

genvar i;
generate
    for(i = 0; i < N; i = i + 1) begin
        if(i == N-1) begin
            // Move the LSB to the MSB
            assign out[i] = a[0]; // Rotate the LSB (a[0]) into MSB (out[N-1])
        end else begin
            // Shift all bits from a one position to the right
            assign out[i] = a[i+1]; // out[i] gets a[i+1], shifting right
        end
    end
endgenerate

endmodule
