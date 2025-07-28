module shift_right_op #(
     N = 8 // ======== MUST BE A LOG BASE 2 NUMBER ========= //
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

parameter LOWER_LENGTH = $clog2(N);
parameter UPPER_LENGTH = N - $clog2(N);

wire [(N > 0) ? N - 1 : 0 : 0] shift_array [(N > 0) ? N : 0 : 0];
wire [(N > 0) ? N - 1 : 0 : 0] shift_res;
wire [(N > 0) ? N - 1 : 0 : 0] shift_array_rotated [(N > 0) ? N - 1 : 0 : 0];

wire [(N > 0) ? LOWER_LENGTH-1 : 0 : 0]  b_lower;
wire [(N > 0) ? UPPER_LENGTH-1 : 0 : 0]  b_upper;

wire enable_not;
wire enable;

wire [(N > 0) ? N-1 : 0 : 0] out_inner;

assign shift_array[0] = a[(N > 0) ? N-1 : 0 : 0];

assign b_lower[LOWER_LENGTH - 1 : 0] = b[LOWER_LENGTH - 1 : 0];
assign b_upper[UPPER_LENGTH - 1 : 0]  = b[N - 1 : LOWER_LENGTH];

or_n_to_1 #(
    .NUM_INPUTS(UPPER_LENGTH)
) u_b_upper_or (
    .a(b_upper),
    .out(enable_not)
);

not (enable, enable_not);

genvar i;
generate
    for(i = 0; i < N; i = i +1) begin
        shift_right_1_bit #(
            .N(N)
        ) u_shift_left (
            .a(shift_array[i][N-1 : 0]),
            .out(shift_array[i+1][N-1 : 0])
        );
    end
endgenerate


genvar j, k; 
generate
    for(j = 0; j < N ; j = j + 1) begin
        for(k = 0; k < N; k = k + 1) begin
            assign shift_array_rotated[j][k] = shift_array[k][j];
        end

        mux #(
            .NUM_INPUTS(N)
        ) u_mux (
            .a(shift_array_rotated[j]),
            .sel(b_lower),
            .out(out_inner[j])
        );

        and (out[j], enable, out_inner[j]);
    end
endgenerate

endmodule