module ram #(
    N = 256
) (
    input wire clk,
    input wire reset,
    input wire read_write,           // read/write signal. 0 for read 1 for write
    input wire enable,
    input wire [$clog2(N) - 1 : 0] addr,  //address of 256 ram
    input wire [31 : 0] data_in,

    output wire [31 : 0] data_out
);


wire read;
wire write;

wire read_decoder_enable;
wire write_decoder_enable;

wire [N - 1 : 0] register_enables;
wire [N - 1 : 0] tristate_buffer_enables;

wire [31 : 0] memory [N - 1:0];

not(read, read_write); 
assign write = read_write;

and (read_decoder_enable, read, enable);
and (write_decoder_enable, write, enable);

decoder_logN_to_N #(
    .N(N)
) read_decoder_for_tristate_buffer (
    .address(addr),
    .enable(read_decoder_enable),
    .out(tristate_buffer_enables)
);

decoder_logN_to_N #(
    .N(N)
) write_decoder_for_register (
    .address(addr),
    .enable(write_decoder_enable),
    .out(register_enables)
);

//Generating all of the registers and tristate buffers 
genvar i;
generate
    for(i = 0 ; i < N; i = i + 1) begin

        // N instances of 32 bit registers
        register #(
            .N(32)
        ) memory_32_bit_registers (
            .clk(clk),              
            .reset(reset),           
            .enable(register_enables[i]),
            .D(data_in),      
            .Q(memory[i])
        );

        //generating the tristate buffer connected directly to the output
        tristate_buffer #(
            .N(32)
        ) tristate_buffer_1 (
            .a(memory[i]),
            .en(tristate_buffer_enables[i]),
            .out(data_out)
        );

    end
endgenerate

endmodule