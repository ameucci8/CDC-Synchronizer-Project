module shift_right_arith_1_bit #(
    N = 8
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

genvar i;
generate
    for(i = N - 1; i >= 0; i = i - 1) begin
        if(i == N - 1) begin
            assign out[i] = a[i];
        end else begin 
            assign out[i] = a[i+1];
        end
    end
endgenerate
endmodule