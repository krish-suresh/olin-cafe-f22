`timescale 1ns/1ps
`default_nettype none
/*
  a 1 bit addder that we can daisy chain for 
  ripple carry adders
*/

module adder_1(a, b, c_in, sum, c_out);

input wire a, b, c_in;
output logic sum, c_out;
always_comb begin
  // Adder logic based on truth table
  sum = (~a & ~b & c_in) | (~a & b & ~c_in) | (a & ~b & ~c_in) | (a & b & c_in); // max term
  c_out = ((a ^ b) & c_in) | (a & b);
end

endmodule
