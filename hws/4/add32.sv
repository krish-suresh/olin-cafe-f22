`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/
module add32(a,b,c_in,sum,c_out);
	//parameter definitions
	input  wire [31:0] a,b;
	input  wire c_in;
	output wire c_out;
	output wire [31:0] sum;
    adder_n #(.N(32)) adder_32bit_a (a,b,c_in,sum,c_out);
endmodule
