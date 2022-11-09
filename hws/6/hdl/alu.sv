`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
parameter N = 32; // Don't need to support other numbers, just using this as a constant.

input wire [N-1:0] a, b; // Inputs to the ALU.
input alu_control_t control; // Sets the current operation.
output logic [N-1:0] result; // Result of the selected operation.

output logic overflow; // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

// Use *only* structural logic and previously defined modules to implement an 
// ALU that can do all of operations defined in alu_types.sv's alu_op_code_t.

logic [N-1:0] adder_sum, sll, sll_o, srl, srl_o, sra, sra_o;
logic c_out;

adder_n #(.N(N)) adder(.a(a), .b(control[2] ? ~b : b), .c_in(control[2]), .sum(adder_sum), .c_out(c_out));
shift_left_logical #(.N(N)) SLL(.in(a), .shamt(b), .out(sll));
shift_right_logical #(.N(N)) SRL(.in(a), .shamt(b), .out(srl));
shift_right_arithmetic #(.N(N)) SRA(.in(a), .shamt(b), .out(sra));
always_comb begin
    overflow = (adder_sum[N-1] ^ a[N-1]) & (~^{a[N-1], b[N-1], control[2]}) & control[3];
    zero = &(result ~^ {N{1'b0}});
    equal = &(a ~^ b);
    sll_o = |b[31:5] ? {N{1'b0}} : sll;
    srl_o = |b[31:5] ? {N{1'b0}} : srl;
    sra_o = |b[31:5] ? {N{1'b0}} : sra;
end
mux16 #(.N(N)) alu_mux( .in01(a & b), // AND
                        .in02(a | b), // OR
                        .in03(a ^ b), // XOR
                        .in05(sll_o), // SLL
                        .in06(srl_o), // SRL
                        .in07(sra_o), // SRA
                        .in08(adder_sum), // ADD
                        .in12(adder_sum), // SUB
                        .in13({31'b0, adder_sum[N-1] ^ overflow}), // SLT
                        .in15({31'b0, ~c_out}), // SLTU
                        .select(control),
                        .out(result));

endmodule