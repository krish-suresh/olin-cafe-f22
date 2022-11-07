`default_nettype none
`timescale 1ns/1ps

module register_file(
  clk, //Note - intentionally does not have a reset! 
  wr_ena, wr_addr, wr_data,
  rd_addr0, rd_data0,
  rd_addr1, rd_data1
);
// Not parametrizing, these widths are defined by the RISC-V Spec!
input wire clk;

// Write channel
input wire wr_ena;
input wire [4:0] wr_addr;
input wire [31:0] wr_data;

// Two read channels
input wire [4:0] rd_addr0, rd_addr1;
output logic [31:0] rd_data0, rd_data1;

logic [31:0] x00; 
always_comb x00 = 32'd0; // ties x00 to ground. 

// DON'T DO THIS:
// logic [31:0] register_file_registers [31:0]
// CAN'T: because that's a RAM. Works in simulation, fails miserably in synthesis.

// Hint - use a scripting language if you get tired of copying and pasting the logic 32 times - e.g. python: print(",".join(["x%02d"%i for i in range(0,32)]))
logic [31:0] x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
mux32 #(.N(32)) mux32_0(x00,x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,rd_addr0,rd_data0);
mux32 #(.N(32)) mux32_1(x00,x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31,rd_addr1,rd_data1);
always_ff @( posedge clk ) begin
  x01 <= (&(wr_addr ~^ 5'b00001) & wr_ena) ? wr_data : x01;
  x02 <= (&(wr_addr ~^ 5'b00010) & wr_ena) ? wr_data : x02;
  x03 <= (&(wr_addr ~^ 5'b00011) & wr_ena) ? wr_data : x03;
  x04 <= (&(wr_addr ~^ 5'b00100) & wr_ena) ? wr_data : x04;
  x05 <= (&(wr_addr ~^ 5'b00101) & wr_ena) ? wr_data : x05;
  x06 <= (&(wr_addr ~^ 5'b00110) & wr_ena) ? wr_data : x06;
  x07 <= (&(wr_addr ~^ 5'b00111) & wr_ena) ? wr_data : x07;
  x08 <= (&(wr_addr ~^ 5'b01000) & wr_ena) ? wr_data : x08;
  x09 <= (&(wr_addr ~^ 5'b01001) & wr_ena) ? wr_data : x09;
  x10 <= (&(wr_addr ~^ 5'b01010) & wr_ena) ? wr_data : x10;
  x11 <= (&(wr_addr ~^ 5'b01011) & wr_ena) ? wr_data : x11;
  x12 <= (&(wr_addr ~^ 5'b01100) & wr_ena) ? wr_data : x12;
  x13 <= (&(wr_addr ~^ 5'b01101) & wr_ena) ? wr_data : x13;
  x14 <= (&(wr_addr ~^ 5'b01110) & wr_ena) ? wr_data : x14;
  x15 <= (&(wr_addr ~^ 5'b01111) & wr_ena) ? wr_data : x15;
  x16 <= (&(wr_addr ~^ 5'b10000) & wr_ena) ? wr_data : x16;
  x17 <= (&(wr_addr ~^ 5'b10001) & wr_ena) ? wr_data : x17;
  x18 <= (&(wr_addr ~^ 5'b10010) & wr_ena) ? wr_data : x18;
  x19 <= (&(wr_addr ~^ 5'b10011) & wr_ena) ? wr_data : x19;
  x20 <= (&(wr_addr ~^ 5'b10100) & wr_ena) ? wr_data : x20;
  x21 <= (&(wr_addr ~^ 5'b10101) & wr_ena) ? wr_data : x21;
  x22 <= (&(wr_addr ~^ 5'b10110) & wr_ena) ? wr_data : x22;
  x23 <= (&(wr_addr ~^ 5'b10111) & wr_ena) ? wr_data : x23;
  x24 <= (&(wr_addr ~^ 5'b11000) & wr_ena) ? wr_data : x24;
  x25 <= (&(wr_addr ~^ 5'b11001) & wr_ena) ? wr_data : x25;
  x26 <= (&(wr_addr ~^ 5'b11010) & wr_ena) ? wr_data : x26;
  x27 <= (&(wr_addr ~^ 5'b11011) & wr_ena) ? wr_data : x27;
  x28 <= (&(wr_addr ~^ 5'b11100) & wr_ena) ? wr_data : x28;
  x29 <= (&(wr_addr ~^ 5'b11101) & wr_ena) ? wr_data : x29;
  x30 <= (&(wr_addr ~^ 5'b11110) & wr_ena) ? wr_data : x30;
  x31 <= (&(wr_addr ~^ 5'b11111) & wr_ena) ? wr_data : x31;
end
endmodule