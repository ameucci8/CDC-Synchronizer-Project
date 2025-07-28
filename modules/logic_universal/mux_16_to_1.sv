module mux_16_to_1 #(
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
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] i,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] j,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] k,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] l,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] m,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] n,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] o,
    input wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] p,

    input wire [3 : 0] sel,
    output wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] z
);

wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] abcdefgh;
wire [(INPUT_BIT_LENGTH > 0) ? INPUT_BIT_LENGTH-1 : 0 : 0] ijklmnop;

mux_8_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    )
    mux1 (
        .a(a), 
        .b(b),
        .c(c),
        .d(d),
        .e(e), 
        .f(f),
        .g(g),
        .h(h), 
        .sel(sel[2:0]),
        .z(abcdefgh)
    );

mux_8_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    ) mux2 (
        .a(i), 
        .b(j),
        .c(k),
        .d(l), 
        .e(m), 
        .f(n),
        .g(o),
        .h(p),
        .sel(sel[2:0]),
        .z(ijklmnop)
    );

mux_2_to_1 #(
        .INPUT_BIT_LENGTH(INPUT_BIT_LENGTH)
    )
    mux3 (
        .a(abcdefgh), 
        .b(ijklmnop), 
        .sel(sel[3]),
        .z(z)
    );

endmodule