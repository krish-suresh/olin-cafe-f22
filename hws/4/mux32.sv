	
`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/
module mux2(
  in00, in01, select,out
);
	//parameter definitions
	parameter N = 32;
	input  wire [(N-1):0] in00, in01;
	input  wire select;
	output logic [(N-1):0] out;
  always_comb out = select ? in01 : in00;
endmodule
module mux4(
  in00, in01, in02, in03,
  select,out
);
	//parameter definitions
	parameter N = 32;
	input  wire [(N-1):0] in00, in01, in02, in03;
	input  wire [1:0] select;
	output logic [(N-1):0] out;

  wire [(N-1):0] m0o, m1o;
  mux2 #(.N(N)) MUX0(.in00(in00), .in01(in01), .select(select[0]), .out(m0o));
  mux2 #(.N(N)) MUX1(.in00(in02), .in01(in03), .select(select[0]), .out(m1o));
  mux2 #(.N(N)) MUX2(.in00(m0o), .in01(m1o), .select(select[1]), .out(out));
endmodule
module mux8(
  in00, in01, in02, in03, in04, in05, in06, in07,
  select,out
);
	//parameter definitions
	parameter N = 32;
	input  wire [(N-1):0] in00, in01, in02, in03, in04, in05, in06, in07;
	input  wire [2:0] select;
	output logic [(N-1):0] out;

  wire [(N-1):0] m0o, m1o;
  mux4 #(.N(N)) MUX0(.in00(in00), .in01(in01), .in02(in02), .in03(in03), .select(select[1:0]), .out(m0o));
  mux4 #(.N(N)) MUX1(.in00(in04), .in01(in05), .in02(in06), .in03(in07), .select(select[1:0]), .out(m1o));
  mux2 #(.N(N)) MUX2(.in00(m0o), .in01(m1o), .select(select[2]), .out(out));
endmodule
module mux16(
  in00, in01, in02, in03, in04, in05, in06, in07, in08, in09, in10, 
  in11, in12, in13, in14, in15,
  select,out
);
	//parameter definitions
	parameter N = 32;
	input  wire [(N-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
    in09, in10, in11, in12, in13, in14, in15;
	input  wire [3:0] select;
	output logic [(N-1):0] out;
  wire [(N-1):0] m0o, m1o;
  mux8 #(.N(N)) MUX0(.in00(in00), .in01(in01), .in02(in02), .in03(in03), .in04(in04), .in05(in05), .in06(in06), .in07(in07),.select(select[2:0]), .out(m0o));
  mux8 #(.N(N)) MUX1(.in00(in08), .in01(in09), .in02(in10), .in03(in11), .in04(in12), .in05(in13), .in06(in14), .in07(in15),.select(select[2:0]), .out(m1o));
  mux2 #(.N(N)) MUX2(.in00(m0o), .in01(m1o), .select(select[3]), .out(out));

endmodule
module mux32(
  in00, in01, in02, in03, in04, in05, in06, in07, in08, in09, in10, 
  in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, 
  in22, in23, in24, in25, in26, in27, in28, in29, in30, in31,
  select,out
);
	//parameter definitions
	parameter N = 32;
	//port definitions
  // python: print(", ".join([f"in{i:02}" for i in range(32)]))
	input  wire [(N-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
    in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
    in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
	input  wire [4:0] select;
	output logic [(N-1):0] out;
  wire [(N-1):0] m0o, m1o;
  mux16 #(.N(N)) MUX0(.in00(in00), .in01(in01), .in02(in02), .in03(in03), .in04(in04), .in05(in05), .in06(in06), .in07(in07),
                     .in08(in08), .in09(in09), .in10(in10), .in11(in11), .in12(in12), .in13(in13), .in14(in14), .in15(in15), .select(select[3:0]), .out(m0o));
  mux16 #(.N(N)) MUX1(.in00(in16), .in01(in17), .in02(in18), .in03(in19), .in04(in20), .in05(in21), .in06(in22), .in07(in23),
                     .in08(in24), .in09(in25), .in10(in26), .in11(in27), .in12(in28), .in13(in29), .in14(in30), .in15(in31),.select(select[3:0]), .out(m1o));
  mux2 #(.N(N)) MUX2(.in00(m0o), .in01(m1o), .select(select[4]), .out(out));

endmodule
