`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
input wire clk;
input wire rst;
input wire ena;

input wire state_0;
output logic state_d;
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
wire [1:0] s0,s1,s2,s3,s4,s5,s6;
logic c_out;
logic [1:0] sum;
always_ff @(posedge clk)
state_q <= state_d;
// adder_n UUT(2'b0,{neighbors[0],1'b0}, 1'b0, s0, c_out);
// adder_n UUT1(s0, {neighbors[1],1'b0}, 1'b0, s1, c_out);
// adder_n UUT2(s1, {neighbors[2],1'b0}, 1'b0, s2, c_out);
// adder_n UUT3(s2, {neighbors[3],1'b0}, 1'b0, s3, c_out);
// adder_n UUT4(s3, {neighbors[4],1'b0}, 1'b0, s4, c_out);
// adder_n UUT5(s4, {neighbors[5],1'b0}, 1'b0, s5, c_out);
// adder_n UUT6(s5, {neighbors[6],1'b0}, 1'b0, s6, c_out);
// adder_n UUT7(s6, {neighbors[7],1'b0}, 1'b0, sum, c_out);
always_comb begin
    sum = 11;
    c_out = 0;
    state_d = ~rst & ((state_0 & (sum & 10 | sum & 11) & ~c_out) | (~state_0 & ((sum & 11) & ~c_out)));

    // r = ~clk & ~state_d;
    // s = ~clk & state_d;
    // q_m = r ~| (s ~| q_m);

    // r_s = clk & ~q_m;
    // s_s = clk & q_m;
    // state_q = r ~| (s ~| state_q);
end


endmodule