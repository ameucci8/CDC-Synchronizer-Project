module mux_4_to_1 #(
    INPUT_BIT_LENGTH = 1 //number of bits being inputted into each mux input
) (
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] a,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] b,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] c,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] d,

    input wire [1 : 0] sel,
    output wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] z
);

wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] ab;
wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] cd;

mux_2_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    )
    mux1 (
        .a(a), 
        .b(b), 
        .sel(sel[0]),
        .z(ab)
    );

mux_2_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    ) mux2 (
        .a(c), 
        .b(d), 
        .sel(sel[0]),
        .z(cd)
    );

mux_2_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    )
    mux3 (
        .a(ab), 
        .b(cd), 
        .sel(sel[1]),
        .z(z)
    );

endmodule