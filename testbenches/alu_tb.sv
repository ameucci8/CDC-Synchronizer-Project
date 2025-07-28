`timescale 1ns / 1ps

module alu_tb;

    // Parameters
    parameter N = 8;

    // Inputs
    reg [(N-1):0] a;
    reg [(N-1):0] b;
    reg [3:0] opcode;

    // Outputs
    wire [(N-1):0] out;
    wire zero_flag;
    wire carry_flag;
    wire overflow_flag;
    wire sign_flag;
    wire parity_flag;
    wire greater_than_flag;
    wire less_than_flag;
    wire equal_to_flag;

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

    // Instantiate the ALU
    alu #( 
        .N(N)
    ) u_alu (
        .a(a),
        .b(b),
        .opcode(opcode),
        .out(out),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .overflow_flag(overflow_flag),
        .sign_flag(sign_flag),
        //.parity_flag(parity_flag),
        .equal_to_flag(equal_to_flag)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        opcode = 0;

        // Wait for global reset
        #100;

       // Test ADD operation
        a = 8'h0A;
        b = 8'h05;
        opcode = 4'b0000;
        #10;
        $display("ADD:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0001;
        #10;
        $display("SUB:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0010;
        #10;
        $display("NAND:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0011;
        #10;
        $display("NOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0100;
        #10;
        $display("AND:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0101;
        #10;
        $display("OR:       a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0110;
        #10;
        $display("XOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0111;
        #10;
        $display("NOT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1000;
        #10;
        $display("SHIFT L:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1001;
        #10;
        $display("SHIFT R:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1010;
        #10;
        $display("ROTATE L: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1011;
        #10;
        $display("ROTATE R: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1100;
        #10;
        $display("SR ARTH:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1101;
        #10;
        $display("SLT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1110;
        #10;
        $display("SLTU:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1111;
        #10;
        $display("NOP:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        $display("");

        
        a = 8'b01110010;
        b = 8'b10010011;
        opcode = 4'b0000;
        #10;
        $display("ADD:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0001;
        #10;
        $display("SUB:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0010;
        #10;
        $display("NAND:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0011;
        #10;
        $display("NOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0100;
        #10;
        $display("AND:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0101;
        #10;
        $display("OR:       a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0110;
        #10;
        $display("XOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0111;
        #10;
        $display("NOT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1000;
        #10;
        $display("SHIFT L:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1001;
        #10;
        $display("SHIFT R:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1010;
        #10;
        $display("ROTATE L: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1011;
        #10;
        $display("ROTATE R: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1100;
        #10;
        $display("SR ARTH:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1101;
        #10;
        $display("SLT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1110;
        #10;
        $display("SLTU:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1111;
        #10;
        $display("NOP:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);


        $display("");

        a = 8'b10110010;
        b = 8'b00000011;
        opcode = 4'b0000;
        #10;
        $display("ADD:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0001;
        #10;
        $display("SUB:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0010;
        #10;
        $display("NAND:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0011;
        #10;
        $display("NOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0100;
        #10;
        $display("AND:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0101;
        #10;
        $display("OR:       a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0110;
        #10;
        $display("XOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0111;
        #10;
        $display("NOT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1000;
        #10;
        $display("SHIFT L:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1001;
        #10;
        $display("SHIFT R:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1010;
        #10;
        $display("ROTATE L: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1011;
        #10;
        $display("ROTATE R: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1100;
        #10;
        $display("SR ARTH:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1101;
        #10;
        $display("SLT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1110;
        #10;
        $display("SLTU:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1111;
        #10;
        $display("NOP:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);



        $display("");

        a = 8'b10001100;
        b = 8'b10101011;
        opcode = 4'b0000;
        #10;
        $display("ADD:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0001;
        #10;
        $display("SUB:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0010;
        #10;
        $display("NAND:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0011;
        #10;
        $display("NOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0100;
        #10;
        $display("AND:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0101;
        #10;
        $display("OR:       a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0110;
        #10;
        $display("XOR:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b0111;
        #10;
        $display("NOT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1000;
        #10;
        $display("SHIFT L:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1001;
        #10;
        $display("SHIFT R:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1010;
        #10;
        $display("ROTATE L: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1011;
        #10;
        $display("ROTATE R: a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1100;
        #10;
        $display("SR ARTH:  a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1101;
        #10;
        $display("SLT:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1110;
        #10;
        $display("SLTU:     a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);

        opcode = 4'b1111;
        #10;
        $display("NOP:      a = %b, b = %b, opcode = %b, out = %b", a, b, opcode, out);
        // Finish simulation
        $stop;
    end

endmodule
