module mux_2_to_1 #(
    INPUT_BIT_LENGTH = 1 //number of bits being inputted into each mux input
) (
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] a,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] b,
    input wire sel,
    output wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] z
);

wire and_a[INPUT_BIT_LENGTH -1 : 0];
wire and_b[INPUT_BIT_LENGTH -1 : 0];
wire inv_sel;

not (inv_sel, sel);

genvar i;
generate
    for (i = 0; i < INPUT_BIT_LENGTH; i++) begin
        and(and_a[i], a[i], inv_sel);
        and(and_b[i], b[i], sel);
        or(z[i], and_a[i], and_b[i]);
    end
endgenerate
endmodule