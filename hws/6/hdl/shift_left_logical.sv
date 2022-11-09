`timescale 1ns/1ps
`default_nettype none
module shift_left_logical(in, shamt, out);

parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

input wire [N-1:0] in;            // the input number that will be shifted left. Fill in the remainder with zeros.
input wire [$clog2(N)-1:0] shamt; // the amount to shift by (think of it as a decimal number from 0 to 31). 
output logic [N-1:0] out;       
mux32 #(.N(N)) MUX32(.in00(in), .in01({in[N-2:0], {1{1'b0}}}), .in02({in[N-3:0], {2{1'b0}}}), .in03({in[N-4:0], {3{1'b0}}}), .in04({in[N-5:0], {4{1'b0}}}), .in05({in[N-6:0], {5{1'b0}}}), .in06({in[N-7:0], {6{1'b0}}}), .in07({in[N-8:0], {7{1'b0}}}), .in08({in[N-9:0], {8{1'b0}}}), .in09({in[N-10:0], {9{1'b0}}}), .in10({in[N-11:0], {10{1'b0}}}), .in11({in[N-12:0], {11{1'b0}}}), .in12({in[N-13:0], {12{1'b0}}}), .in13({in[N-14:0], {13{1'b0}}}), .in14({in[N-15:0], {14{1'b0}}}), .in15({in[N-16:0], {15{1'b0}}}), .in16({in[N-17:0], {16{1'b0}}}), .in17({in[N-18:0], {17{1'b0}}}), .in18({in[N-19:0], {18{1'b0}}}), .in19({in[N-20:0], {19{1'b0}}}), .in20({in[N-21:0], {20{1'b0}}}), .in21({in[N-22:0], {21{1'b0}}}), .in22({in[N-23:0], {22{1'b0}}}), .in23({in[N-24:0], {23{1'b0}}}), .in24({in[N-25:0], {24{1'b0}}}), .in25({in[N-26:0], {25{1'b0}}}), .in26({in[N-27:0], {26{1'b0}}}), .in27({in[N-28:0], {27{1'b0}}}), .in28({in[N-29:0], {28{1'b0}}}), .in29({in[N-30:0], {29{1'b0}}}), .in30({in[N-31:0], {30{1'b0}}}), .in31({in[N-32:0], {31{1'b0}}}),.select(shamt), .out(out));
endmodule
