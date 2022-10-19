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
logic [1:0] s1,s2,s3,s4,s5,s6; // Sum outputs 
wire c1,c2,c3,c4,c5,c6,c7; // Adder carries
logic c_out; // Overall sum carry
logic [1:0] sum; // Sum storage

// Add all individual neighbor values to the sum
adder_n ADDER1({1'b0,neighbors[0]}, {1'b0,neighbors[1]},1'b0, s1, c1);
adder_n ADDER2(s1, {1'b0, neighbors[2]}, 1'b0, s2, c2);
adder_n ADDER3(s2, {1'b0, neighbors[3]}, 1'b0, s3, c3);
adder_n ADDER4(s3, {1'b0, neighbors[4]}, 1'b0, s4, c4);
adder_n ADDER5(s4, {1'b0, neighbors[5]}, 1'b0, s5, c5);
adder_n ADDER6(s5, {1'b0, neighbors[6]}, 1'b0, s6, c6);
adder_n ADDER7(s6, {1'b0, neighbors[7]}, 1'b0, sum, c7);

always_comb begin
    // ORing the carries allow for easy detection of more than 3 neighbors
    c_out = c1|c2|c3|c4|c5|c6|c7;
    // The left half is the case when the current state is alive and we want to maintain living only when the neighbor sum is 2 or 3
    // The right half is for when the cell is dead and we only want to make it alive when neighbor sum is 3
    state_d = ((state_q & sum[1] & ~c_out) | (~state_q & &sum & ~c_out));
end

// Flip flop to sync the setting of state_q
always_ff @(posedge clk) begin
    // On rst, set state_q to the initial state
    if (rst) begin
        state_q = state_0;
    end 
    else begin
        // Only pass the next value of the conway cell to state q when cell is enabled
        if (ena) begin
            state_q <= state_d;
        end 
    end

end


endmodule