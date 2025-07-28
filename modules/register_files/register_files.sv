module register_files #(
    NUM_ADDRESS = 16,
    DATA_LENGTH = 32
) (
    input wire                                                       clk,
    input wire                                                       reset,
    input wire                                                       write_enable,

    input wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] read_address_1,
    input wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] read_address_2,
    input wire [(NUM_ADDRESS > 0) ? $clog2(NUM_ADDRESS) - 1 : 0 : 0] write_address,
    input wire [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0]         write_data_in,

    output wire [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0]        read_data_out_1,
    output wire [(DATA_LENGTH > 0) ? DATA_LENGTH - 1 : 0 : 0]        read_data_out_2
);

wire [DATA_LENGTH - 1 : 0] register_file_memory [NUM_ADDRESS - 1:0];

wire [NUM_ADDRESS - 1 : 0] decoder_to_register_enables;


//Decoder taking in write address and outputting the enables for the register files
decoder_logN_to_N #(
    .N(NUM_ADDRESS)
) write_decoder_for_register (
    .address(write_address),
    .enable(write_enable),
    .out(decoder_to_register_enables)
);

genvar i;
generate
    for(i = 0 ; i < NUM_ADDRESS; i = i + 1) begin

        // Each instance of a regsiter file
        register #(
            .N(DATA_LENGTH)
        ) memory_32_bit_registers (
            .clk(clk),              
            .reset(reset),           
            .enable(decoder_to_register_enables[i]),
            .D(write_data_in),      
            .Q(register_file_memory[i])
        );

    end
endgenerate


//2 muxes for reading register files
mux_N_bit_length #(
    .NUM_INPUTS(NUM_ADDRESS),
    .NUM_BITS(DATA_LENGTH)
) mux_data_1 (
    .a(register_file_memory),
    .sel(read_address_1),
    .out(read_data_out_1)
);

mux_N_bit_length #(
    .NUM_INPUTS(NUM_ADDRESS),
    .NUM_BITS(DATA_LENGTH)
) mux_data_2 (
    .a(register_file_memory),
    .sel(read_address_2),
    .out(read_data_out_2)
);

    
endmodule