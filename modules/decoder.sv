module decoder #( 
    parameter N = 2  // number of input bits (log2 of the number of outputs)
)(
    input  wire [N-1:0] a,       // n-bit input
    output wire [(2**N)-1:0] y   // 2^N output lines
);

    // generate all NOT combinations of inputs
    wire [N-1:0] a_not;
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            not (a_not[i], a[i]);  // create inverted versions of all input bits
        end
    endgenerate

    // generate each output line based on the input combinations
    genvar j;
    generate
        for (j = 0; j < (2**N); j = j + 1) begin // runs 2^N times
            assign y[j] = and_generate(a, a_not, j);  // assign output lines structurally
        end
    endgenerate

endmodule


/*

// AND gate generator for each output combination
function and and_generate;
    input [N-1:0] a;       // original input bits (N-bit input)
    input [N-1:0] a_not;   // inverted input bits (N-bit inverted input)
    input integer idx;     // current index (which output line we're generating)

    integer k;          
    begin
        and_generate = 1'b1;  // initialize the output to 1 (logical AND identity)
        for (k = 0; k < N; k = k + 1) begin
            if (idx[k] == 1) begin
                // If the k-th bit of index 'idx' is 1, use the original input bit a[k]
                and_generate = and_generate & a[k];      
            end else begin
                // If the k-th bit of index 'idx' is 0, use the inverted input bit a_not[k]
                and_generate = and_generate & a_not[k];  
            end
        end
    end

    
endfunction

*/


