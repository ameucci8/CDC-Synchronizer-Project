module rom_tb();


parameter N = 64;

reg [$clog2(N)-1 : 0] address;
wire [31:0] data_out;

rom #(
    .N(N)
) instruction_memory (
    .address(address),
    .data_out(data_out)
);

initial begin
    force instruction_memory.enable = 1'b1;

    #10;

    //writing assembly code
    force instruction_memory.firmware_data[0] = 32'hDEADBABE;
    force instruction_memory.firmware_data[1] = 32'hDEAD0101;
    force instruction_memory.firmware_data[2] = 32'hDEAD1234;
    force instruction_memory.firmware_data[3] = 32'hDEAD8888;
    #10;

    force instruction_memory.enable = 1'b0;

    #10;

    address = 6'b000000;
     
    #10;

    address = 6'b000001;

    #10;

    address = 6'b000010;

    #10;

    address = 6'b000011;

    #10;

    $stop;

end

initial begin
    $monitor("address = %b | data_out = %b", address, data_out);
end 

endmodule