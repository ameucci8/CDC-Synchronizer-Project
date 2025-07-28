module d_latch #(
    N = 8 
  )(
  input logic [(N > 0) ? N-1 : 0 : 0] data,    // set input
  input logic enable,   // reset input
  output logic [(N > 0) ? N-1 : 0 : 0] Q,   // Output
  output logic [(N > 0) ? N-1 : 0 : 0] Qn   // Inverted output
);

always @(data or enable) begin
    if(enable) begin
      Q <= data;
      Qn <= ~data;
    end
end

endmodule
