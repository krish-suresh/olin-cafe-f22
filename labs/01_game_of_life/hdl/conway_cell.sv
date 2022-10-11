`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
input wire clk;
input wire rst;
input wire ena;

input wire state_0;
output logic state_d; // NOTE - this is only an output of the module for debugging purposes. 
output logic state_q;

input wire [7:0] neighbors;

/*
Any live cell with two or three live neighbours survives (becomes 1'b1 at posedge clk).
Any dead cell with three live neighbours becomes a live cell (becomes 1'b1 at posedge clk).
All other live cells die in the next generation. Similarly, all other dead cells stay dead. (becomes 1'b0 at posedge clk).
*/

// Sum neighbors with 2 bit adder
// state_0 & (sum & 10 | sum & 11) & ~c_out
// ~state_0 & ((sum & 11) & ~c_out)
logic [1:0] s0,s1,s2,s3,s4,s5,s6;
wire c0,c1,c2,c3,c4,c5,c6,c7;
logic c_out;
logic [1:0] sum;
adder_n ADDER({1'b0,neighbors[0]}, {1'b0,neighbors[1]},1'b0, s0, c0);
adder_n UUT1(s0, {1'b0, neighbors[2]}, 1'b0, s1, c1);
adder_n UUT2(s1, {1'b0, neighbors[2]}, 1'b0, s2, c2);
adder_n UUT3(s2, {1'b0, neighbors[3]}, 1'b0, s3, c3);
adder_n UUT4(s3, {1'b0, neighbors[4]}, 1'b0, s4, c4);
adder_n UUT5(s4, {1'b0, neighbors[5]}, 1'b0, s5, c5);
adder_n UUT6(s5, {1'b0, neighbors[6]}, 1'b0, s6, c6);
adder_n UUT7(s6, {1'b0, neighbors[7]}, 1'b0, sum, c7);
// always @(sum or c_out) begin
//     $display("s(%d %b", {c_out,sum},  neighbors);
// end
always_comb begin
    c_out = c0|c1 |c2|c3|c4|c5|c6|c7;
    state_d = ~rst & ((state_0 & ((sum & 10) | (sum & 11)) & ~c_out) | (~state_0 & ((sum & 11) & ~c_out)));
end
always_ff @(posedge clk)
    state_q <= state_d;


endmodule