`timescale 1ns/1ps
`default_nettype none
module shift_right_logical(in,shamt,out);
parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

//port definitions
input  wire [N-1:0] in;    // A 32 bit input
input  wire [$clog2(N)-1:0] shamt; // Amount we shift by.
output wire [N-1:0] out;  // Output.
mux32 #(.N(N)) MUX32(.in00(in), .in01({{1{1'b0}}, in[N-1:1]}), .in02({{2{1'b0}}, in[N-1:2]}), .in03({{3{1'b0}}, in[N-1:3]}), .in04({{4{1'b0}}, in[N-1:4]}), .in05({{5{1'b0}}, in[N-1:5]}), .in06({{6{1'b0}}, in[N-1:6]}), .in07({{7{1'b0}}, in[N-1:7]}), .in08({{8{1'b0}}, in[N-1:8]}), .in09({{9{1'b0}}, in[N-1:9]}), .in10({{10{1'b0}}, in[N-1:10]}), .in11({{11{1'b0}}, in[N-1:11]}), .in12({{12{1'b0}}, in[N-1:12]}), .in13({{13{1'b0}}, in[N-1:13]}), .in14({{14{1'b0}}, in[N-1:14]}), .in15({{15{1'b0}}, in[N-1:15]}), .in16({{16{1'b0}}, in[N-1:16]}), .in17({{17{1'b0}}, in[N-1:17]}), .in18({{18{1'b0}}, in[N-1:18]}), .in19({{19{1'b0}}, in[N-1:19]}), .in20({{20{1'b0}}, in[N-1:20]}), .in21({{21{1'b0}}, in[N-1:21]}), .in22({{22{1'b0}}, in[N-1:22]}), .in23({{23{1'b0}}, in[N-1:23]}), .in24({{24{1'b0}}, in[N-1:24]}), .in25({{25{1'b0}}, in[N-1:25]}), .in26({{26{1'b0}}, in[N-1:26]}), .in27({{27{1'b0}}, in[N-1:27]}), .in28({{28{1'b0}}, in[N-1:28]}), .in29({{29{1'b0}}, in[N-1:29]}), .in30({{30{1'b0}}, in[N-1:30]}), .in31({{31{1'b0}}, in[N-1:31]}),.select(shamt), .out(out));
endmodule
