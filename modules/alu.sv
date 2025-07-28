
module alu #( 
    parameter N = 8
)(
    input wire [(N > 0) ? N-1 : 0 : 0] a,
    input wire [(N > 0) ? N-1 : 0 : 0] b,
    input wire [3:0] opcode,
    output wire [(N > 0) ? N-1 : 0 : 0] out,
    output wire zero_flag,                  //if result of operation is zero
    output wire carry_flag,                 //if result of operation contains carry
    output wire overflow_flag,              //if result contains overflow
    output wire sign_flag,                  //if result of operation is negative
    //output wire parity_flag,                //if number of set bits is even (0) or odd (1)
    output wire equal_to_flag
);


//ALU opcodes
/*
0000: ADD
0001: SUB
0010: NAND
0011: NOR

0100: AND
0101: OR
0110: XOR
0111: NOT

1000: SHIFT LEFT
1001: SHIFT RIGHT
1010: ROTATE LEFT
1011: ROTATE RIGHT

1100: SHIFT RIGHT ARITHMATIC
1101: SET LESS THAN (SET to 1)
1110: SET LESS THAN UNSIGNED
1111: NOP
*/


//output wires
wire [(N > 0) ? N-1 : 0 : 0] adder_out;
wire [(N > 0) ? N-1 : 0 : 0] subtractor_out;
wire [(N > 0) ? N-1 : 0 : 0] nand_out;
wire [(N > 0) ? N-1 : 0 : 0] nor_out;
wire [(N > 0) ? N-1 : 0 : 0] and_out;
wire [(N > 0) ? N-1 : 0 : 0] or_out;
wire [(N > 0) ? N-1 : 0 : 0] xor_out;
wire [(N > 0) ? N-1 : 0 : 0] not_out;
wire [(N > 0) ? N-1 : 0 : 0] shiftL_out;
wire [(N > 0) ? N-1 : 0 : 0] shiftR_out;
wire [(N > 0) ? N-1 : 0 : 0] rotateL_out;
wire [(N > 0) ? N-1 : 0 : 0] rotateR_out;
wire [(N > 0) ? N-1 : 0 : 0] shiftR_arith_out;
wire [(N > 0) ? N-1 : 0 : 0] less_than_out;
wire [(N > 0) ? N-1 : 0 : 0] less_than_unsigned_out;


wire zero_f;
wire equal_to_flag_n;

//carry wires
wire adder_carry;
wire subtractor_carry;

//overflow wires
wire adder_overflow;
wire subtractor_overflow;


//instantiations
adder_n_bit #(
    .N(N)
) adder1 (
    .a(a),
    .b(b),
    .cin(1'b0),
    .sum(adder_out),
    .cout(adder_carry),
    .overflow(adder_overflow)
);

subtractor #(
    .N(N)
) subtractor1 (
    .a(a),
    .b(b),
    .cin(1'b1),
    .sum(subtractor_out),
    .cout(subtractor_carry),
    .overflow(subtractor_overflow)
);

nand_op #(
    .N(N)
) nand_op1 (
    .a(a),
    .b(b),
    .out(nand_out)
);

nor_op #(
    .N(N)
) nor_op1 (
    .a(a),
    .b(b),
    .out(nor_out)
);


and_op #(
    .N(N)
) and_op1 (
    .a(a),
    .b(b),
    .out(and_out)
);

or_op #(
    .N(N)
) or_op1 (
    .a(a),
    .b(b),
    .out(or_out)
);



xor_op #(
    .N(N)
) xor_op1 (
    .a(a),
    .b(b),
    .out(xor_out)
);

not_op #(
    .N(N)
) not_op1 (
    .a(a),
    .out(not_out)
);


shift_left_op #(
    .N(N)
) shift_left_op1 (
    .a(a),
    .b(b),
    .out(shiftL_out)
);

shift_right_op #(
    .N(N)
) shift_right_op1 (
    .a(a),
    .b(b),
    .out(shiftR_out)
);

rotate_left_op #(
    .N(N)
) rotate_left_op1 (
    .a(a),
    .b(b),
    .out(rotateL_out)
);

rotate_right_op #(
    .N(N)
) rotate_right_op1 (
    .a(a),
    .b(b),
    .out(rotateR_out)
);

shift_right_arith_op #(
    .N(N)
) shift_right_arith_op1 (
    .a(a),
    .b(b),
    .out(shiftR_arith_out)
);


less_than #(
    .N(N)
) less_than1 (
    .a(a),
    .b(b),
    .out(less_than_out)
);

less_than_unsigned #(
    .N(N)
) less_than_unsigned1 (
    .a(a),
    .b(b),
    .out(less_than_unsigned_out)
);

mux_16_to_1 #(
    .INPUT_BIT_LENGTH(N)
) mux1 (
    .a(adder_out),
    .b(subtractor_out),
    .c(nand_out),
    .d(nor_out),
    .e(and_out),
    .f(or_out),
    .g(xor_out),
    .h(not_out),
    .i(shiftL_out),
    .j(shiftR_out),
    .k(rotateL_out),
    .l(rotateR_out),
    .m(shiftR_arith_out),
    .n(less_than_out),
    .o(less_than_unsigned_out),
    .p(a),
    .sel(opcode),
    .z(out)
);


//ZERO FLAG
or_n_to_1 #(
    .NUM_INPUTS(N)
) zero_flag1 (
    .a(out),
    .out(zero_f)
);

not (zero_flag, zero_f);


//CARRY FLAG
mux_16_to_1 #(
    .INPUT_BIT_LENGTH(1)
) mux_carry (
    .a(adder_carry),
    .b(subtractor_carry),
    .c(1'b0),
    .d(1'b0),
    .e(1'b0),
    .f(1'b0),
    .g(1'b0),
    .h(1'b0),
    .i(1'b0),
    .j(1'b0),
    .k(1'b0),
    .l(1'b0),
    .m(1'b0),
    .n(1'b0),
    .o(1'b0),
    .p(1'b0),
    .sel(opcode),
    .z(carry_flag)
);


//OVERFLOW FLAG 
mux_16_to_1 #(
    .INPUT_BIT_LENGTH(1)
) mux_overflow (
    .a(adder_overflow),
    .b(subtractor_overflow),
    .c(1'b0),
    .d(1'b0),
    .e(1'b0),
    .f(1'b0),
    .g(1'b0),
    .h(1'b0),
    .i(1'b0),
    .j(1'b0),
    .k(1'b0),
    .l(1'b0),
    .m(1'b0),
    .n(1'b0),
    .o(1'b0),
    .p(1'b0),
    .sel(opcode),
    .z(overflow_flag)
);

//SIGN FLAG
assign sign_flag = out[N-1];

//EQUAL TO FLAG
or_n_to_1 #(
    .NUM_INPUTS(N)
) equal_flag_or (
    .a(xor_out),
    .out(equal_to_flag_n)
);

not (equal_to_flag, equal_to_flag_n);



endmodule