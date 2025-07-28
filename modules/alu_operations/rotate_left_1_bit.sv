module rotate_left_1_bit #(
    N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

genvar i;
generate
    for(i = 0; i < N; i = i + 1) begin
        if(i == 0) begin
            // move the MSB to the LSB
            assign out[i] = a[N-1]; // rotate MSB (a[N-1]) into LSB (out[0])
        end else begin 
            // shift all bits from a one position to the left
            assign out[i] = a[i-1]; // out[i] gets a[i-1], shifting left
        end
    end
endgenerate

endmodule
