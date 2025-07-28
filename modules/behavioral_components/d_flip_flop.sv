module d_flip_flop (
  input logic D,    // Data input
  input logic clk,  // Clock input
  output logic Q,   // Output
  output logic Qn   // Inverted output
);

always @(posedge clk) begin
    Q <= D;
end
  

not(Qn, Q);

endmodule
