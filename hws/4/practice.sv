`timescale 1ns/1ps
`default_nettype none

module practice(rst, clk, ena, seed, out);

input wire rst, clk, ena, seed;
output logic out;

logic d0,n0,n1;
always_comb d0 = ena ? n0 ^ n1 : seed;
always_ff @(posedge clk) begin
    n0 <= ~rst & d0;
    n1 <= ~rst & n0; 
    out <= ~rst & n1; 
end

endmodule
