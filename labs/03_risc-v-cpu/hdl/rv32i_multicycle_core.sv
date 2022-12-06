`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"
`include "rv32i_defines.sv"

module rv32i_multicycle_core(
  clk, rst, ena,
  mem_addr, mem_rd_data, mem_wr_data, mem_wr_ena,
  PC
);

parameter PC_START_ADDRESS=0;

// Standard control signals.
input  wire clk, rst, ena; // <- worry about implementing the ena signal last.

// Memory interface.
output logic [31:0] mem_addr, mem_wr_data;
input   wire [31:0] mem_rd_data;
output logic mem_wr_ena;

// Program Counter
output wire [31:0] PC;
wire [31:0] PC_old;
logic PC_ena, ir_write;
logic [31:0] PC_next; 

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(ir_write), .d(PC), .q(PC_old)
);

//  an example of how to make named inputs for a mux:
/*
    enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
    always_comb begin : memory_read_address_mux
      case(mem_src)
        MEM_SRC_RESULT : mem_rd_addr = alu_result;
        MEM_SRC_PC : mem_rd_addr = PC;
        default: mem_rd_addr = 0;
    end
*/

// Register file
logic reg_write;
logic [4:0] rd, rs1, rs2;
logic [31:0] rfile_wr_data;
wire [31:0] reg_data1, reg_data2;
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(reg_write), .wr_addr(rd), .wr_data(rfile_wr_data),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(reg_data1), .rd_data1(reg_data2)
);

// ALU and related control signals
// Feel free to replace with your ALU from the homework.
logic [31:0] src_a, src_b;
alu_control_t alu_control;
wire [31:0] alu_result;
wire overflow, zero, equal;
alu_behavioural ALU (
  .a(src_a), .b(src_b), .result(alu_result),
  .control(alu_control),
  .overflow(overflow), .zero(zero), .equal(equal)
);

// Implement your multicycle rv32i CPU here!

enum logic [3:0] {FETCH, DECODE, MEM_ADR, MEM_READ, MEM_WB, MEM_WRITE, EXECUTE_R, EXECUTE_I, ALU_WB, BRANCH, JAL, JALR} state;

logic [31:0] instr, result, A, alu_out, data, imm_ext;
logic [1:0] alu_src_a, alu_src_b, result_src, alu_op;
logic [6:0] op;
logic [2:0] funct3;
logic funct7, branch, pc_update, adr_src;

always_comb begin
  op = instr[6:0];
  funct3 = instr[14:12];
  funct7 = instr[30];
  rs1 = instr[19:15];
  rs2 = instr[24:20];
  rd = instr[11:7];
  PC_ena = pc_update | ( branch & (funct3[0] ? ~zero : zero) );
  // muxes
  mem_addr = adr_src ? result : PC;
  src_a = alu_src_a[1] ? A : (alu_src_a[0] ? PC_old : PC);
  src_b = alu_src_b[1] ? 4 : (alu_src_b[0] ? imm_ext : mem_wr_data);
  result = result_src[1] ? alu_result : (result_src[0] ? data : alu_out);
  PC_next = result;
  rfile_wr_data = result;
end

always_comb begin : instr_decoder
  case (op)
    7'b0000011: imm_src = I_EXTEND;
    7'b0100011: imm_src = S_EXTEND; 
    7'b1100011: imm_src = B_EXTEND; 
    7'b0010011: imm_src = I_EXTEND; 
    7'b1101111: imm_src = J_EXTEND; 
  endcase
end

// imm extend
enum logic [1:0] {I_EXTEND, S_EXTEND, B_EXTEND, J_EXTEND} imm_src;
always_comb begin : imm_ext_mux
  imm_ext = instr[31] ? {{7{1'b1}}, instr[31:7]} : {{7{1'b0}}, instr[31:7]};
  case (imm_src)
    I_EXTEND: imm_ext = {{20{instr[31]}}, instr[31:20]};
    S_EXTEND: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
    B_EXTEND: imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
    J_EXTEND: imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
  endcase
end

always_comb begin : control_signals
  case (state)
    FETCH     : begin
      branch = 0;
      mem_wr_ena = 0;
      adr_src = 0;
      pc_update = 1;
      ir_write = 1;
      reg_write = 0;
      alu_src_a = 2'b00;
      alu_src_b = 2'b10;
      alu_op = 2'b00;
      result_src = 2'b10;
    end
    DECODE    : begin
      pc_update = 0;
      ir_write = 0;
      alu_src_a = 2'b01;
      alu_src_b = 2'b01;
      alu_op = 2'b00;
    end
    MEM_ADR : begin
      alu_src_a = 2'b10;
      alu_src_b = 2'b01;
      alu_op = 2'b00;
    end
    MEM_READ  : begin
      result_src = 2'b00;
      adr_src = 1;
    end
    MEM_WB    : begin
      result_src = 2'b01;
      reg_write = 1;
    end
    MEM_WRITE : begin
      result_src = 2'b00;
      adr_src = 1;
      mem_wr_ena = 1;
    end
    EXECUTE_R : begin
      alu_src_a = 2'b10;
      alu_src_b = 2'b00;
      alu_op = 2'b10;
    end
    EXECUTE_I : begin
      alu_src_a = 2'b10;
      alu_src_b = 2'b01;
      alu_op = 2'b10;
    end
    ALU_WB    : begin
      result_src = 2'b00;
      reg_write = 1;
      pc_update = 0;
    end
    BRANCH    : begin
      alu_src_a = 2'b10;
      alu_src_b = 2'b01;
      alu_op = 2'b01;
      result_src = 2'b00;
      branch = 1;
    end
    JAL       : begin
      alu_src_a = 2'b01;
      alu_src_b = 2'b10;
      alu_op = 2'b00;
      result_src = 2'b00;
      pc_update = 1;
    end
    JALR       : begin
      alu_src_a = 2'b10;
      alu_src_b = 2'b01;
      alu_op = 2'b00;
      result_src = 2'b10;
      pc_update = 1;
    end
  endcase
end

always_comb begin : alu_decoder
  case (alu_op)
    2'b00: alu_control = ALU_ADD;
    2'b01: alu_control = ALU_SUB;
    2'b10: begin
      case (funct3)
        3'b000: begin 
          if (op[5] & funct7) begin
            alu_control = ALU_SUB;
          end else begin
            alu_control = ALU_ADD;
          end
        end
        3'b001: alu_control = ALU_SLL;
        3'b010: alu_control = ALU_SLT;
        3'b011: alu_control = ALU_SLTU;
        3'b100: alu_control = ALU_XOR;
        3'b101: alu_control = ALU_SRA;
        3'b110: alu_control = ALU_OR;
        3'b111: alu_control = ALU_AND;
        default: alu_control = ALU_INVALID;
      endcase
    end
    default: alu_control = ALU_INVALID;
  endcase
end

always_ff @( posedge clk ) begin
  if (rst) begin
    state <= FETCH;
    reg_write <= 0;
  end else begin
    A <= reg_data1;
    mem_wr_data <= reg_data2;
    alu_out <= alu_result;
    data <= mem_rd_data;
    instr <= ir_write ? mem_rd_data : instr;

    case (state)
      FETCH: state <= DECODE;
      DECODE: begin
        case (op)
          7'b0000011: state <= MEM_ADR;
          7'b0100011: state <= MEM_ADR;
          7'b0110011: state <= EXECUTE_R;
          7'b0010011: state <= EXECUTE_I;
          7'b1101111: state <= JAL;
          7'b1100111: state <= JALR;
          7'b1100011: state <= BRANCH;
        endcase
        
      end
      MEM_ADR: begin
        case (op)
          7'b0000011: state <= MEM_READ;
          7'b0100011: state <= MEM_WRITE;
        endcase
      end
      MEM_READ: state <= MEM_WB;
      MEM_WRITE: state <= FETCH;
      EXECUTE_R: state <= ALU_WB;
      EXECUTE_I: state <= ALU_WB;
      JAL: state <= ALU_WB;
      JALR: state <= ALU_WB;
      ALU_WB: state <= FETCH;
      MEM_WB: state <= FETCH;
      BRANCH: state <= FETCH;
    endcase
  end
end
endmodule
