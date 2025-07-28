module mux_8_to_1 #(
    INPUT_BIT_LENGTH = 1 //number of bits being inputted into each mux input
) (
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] a,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] b,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] c,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] d,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] e,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] f,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] g,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] h,

    input wire [2 : 0] sel,
    output wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] z
);

wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] abcd;
wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] efgh;

mux_4_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    )
    mux1 (
        .a(a), 
        .b(b),
        .c(c),
        .d(d), 
        .sel(sel[1:0]),
        .z(abcd)
    );

mux_4_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    ) mux2 (
        .a(e), 
        .b(f),
        .c(g),
        .d(h), 
        .sel(sel[1:0]),
        .z(efgh)
    );

mux_2_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    )
    mux3 (
        .a(abcd), 
        .b(efgh), 
        .sel(sel[2]),
        .z(z)
    );

endmodule