module register #(
  parameter N = 8  // Default width of the register is 8 bits
)(
  input wire clk,       // Clock input
  input wire reset,     // Reset input
  input wire enable,    // Enable input
  input wire [N-1:0] D, // Data input
  output reg [N-1:0] Q  // Data output
);

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      Q <= {N{1'b0}}; 
    end else if (enable) begin
      Q <= D;   
    end
  end

endmodule
