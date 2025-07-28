module rotate_left_op #(
    N = 8 // ======== MUST BE A LOG BASE 2 NUMBER ========= //
) (
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    output wire [(N > 0) ? N-1 : 0 : 0] out
);

parameter LOWER_LENGTH = $clog2(N);

wire [(N > 0) ? N - 1 : 0 : 0] rotate_array [(N > 0) ? N : 0 : 0];
wire [(N > 0) ? N - 1 : 0 : 0] rotate_res;
wire [(N > 0) ? N - 1 : 0 : 0] rotate_array_rotated [(N > 0) ? N - 1 : 0 : 0];

wire [(N > 0) ? LOWER_LENGTH-1 : 0 : 0]  b_lower;

wire enable_not;
wire enable;

wire [(N > 0) ? N-1 : 0 : 0] out_inner;

assign rotate_array[0] = a[(N > 0) ? N-1 : 0 : 0];

assign b_lower[LOWER_LENGTH - 1 : 0] = b[LOWER_LENGTH - 1 : 0];

genvar i;
generate
    for(i = 0; i < N; i = i +1) begin
        rotate_left_1_bit #(
            .N(N)
        ) u_rotate_left (
            .a(rotate_array[i][N-1 : 0]),
            .out(rotate_array[i+1][N-1 : 0])
        );
    end
endgenerate

genvar j, k; 
generate
    for(j = 0; j < N ; j = j + 1) begin
        for(k = 0; k < N; k = k + 1) begin
            assign rotate_array_rotated[j][k] = rotate_array[k][j];
        end

        mux #(
            .NUM_INPUTS(N)
        ) u_mux (
            .a(rotate_array_rotated[j]),
            .sel(b_lower),
            .out(out_inner[j])
        );

        assign out[j] = out_inner[j];
    end
endgenerate



endmodule