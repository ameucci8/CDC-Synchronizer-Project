module branch_control_unit (
    input wire [1:0] branch_type,   //specifies branch type (00 = beq, 01 = bne, 10 = blez, 11 = bgtz)
    input wire zero_flag,           //specifies if ALU result is zero (1)
    input wire sign_flag,           //specifies if ALU result is positive (0) or negative (1)
    input wire branch,              //specifies if instruction is branch type
    output wire branch_valid        //specifies if program counter takes branch address
);

wire zero_not;
wire sign_not;
wire less_than_eq_zero;
wire greater_than_zero;
wire branch_condition_valid;
wire [3:0] branch_mux_inputs;

not(zero_not, zero_flag);
not(sign_not, sign_flag);
or(less_than_eq_zero, sign_flag, zero_flag);
and(greater_than_zero, zero_not, sign_not);

assign branch_mux_inputs[0] = zero_flag;            //beq: branches if zero_flag = 1
assign branch_mux_inputs[1] = zero_not;             //bne: branches if zero_flag = 0
assign branch_mux_inputs[2] = less_than_eq_zero;    //blez: branches if ALU result is less than or equal to zero
assign branch_mux_inputs[3] = greater_than_zero;    //bgtz: branches if ALU result is greater than zero

mux #(
    .NUM_INPUTS(4)
) branch_control_mux (
    .a(branch_mux_inputs),
    .sel(branch_type),
    .out(branch_condition_valid)
);

and(branch_valid, branch, branch_condition_valid);


endmodule

