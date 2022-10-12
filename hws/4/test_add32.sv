
`timescale 1ns/1ps
`default_nettype none

module test_add32;
parameter N = 32;
logic [(N-1):0] a,b;
logic c_in;
logic [(N-1):0] sum;
logic c_out;
add32 #(.N(N)) UUT(.a(a),.b(b),.c_in(c_in),.sum(sum),.c_out(c_out));
initial begin
  $dumpfile("add32.fst");
  $dumpvars(0, UUT);
  // Test carry
  a = 32'b1;
  b = 32'b11111111111111111111111111111111;
  c_in = 0;
  #1 $display("%b + %b + %b = %b|%b", a,b,c_in,c_out,sum);
  a = 32'b0;
  b = 32'b11111111111111111111111111111111;
  c_in = 0;
  #1 $display("%b + %b + %b = %b|%b", a,b,c_in,c_out,sum);
  a = 32'b0;
  b = 32'b11111111111111111111111111111111;
  c_in = 1;
  #1 $display("%b + %b + %b = %b|%b", a,b,c_in,c_out,sum);
  a = 32'b0;
  b = 32'b0;
  c_in = 0;
  #1 $display("%b + %b + %b = %b|%b", a,b,c_in,c_out,sum);
  a = 32'b1;
  b = 32'b1;
  c_in = 1;
  #1 $display("%b + %b + %b = %b|%b", a,b,c_in,c_out,sum);
  $finish;
end


endmodule
