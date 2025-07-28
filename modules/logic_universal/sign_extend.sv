module sign_extend #(
    NUM_INPUTS = 16,
    NUM_OUTPUTS = 32 //NUM_OUTPUTS  > NUM_INPUTS
) (
    input wire [(NUM_INPUTS > 0) ? NUM_INPUTS - 1 : 0 : 0] a,
    input wire [(NUM_OUTPUTS > 0) ? NUM_OUTPUTS - 1 : 0 : 0] z
);


genvar i;
generate;
    if (NUM_INPUTS < NUM_OUTPUTS) begin
        for(i = 0; i < NUM_OUTPUTS; i = i + 1) begin
            if( i < NUM_INPUTS) begin
                assign z[i] = a[i];
            end else begin
                assign z[i] = a[NUM_INPUTS - 1];
            end
        end 
    end 
endgenerate

endmodule