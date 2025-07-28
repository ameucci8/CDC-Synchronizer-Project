module tristate_buffer_1_bit (
    input  wire a,
    input  wire en,
    output wire out
);


// Tristate buffer logic
assign out = (en) ? a : 'z;

endmodule