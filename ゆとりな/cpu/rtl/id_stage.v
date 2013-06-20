`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "exp.h"
`include "gpr.h"
`include "spr.h"

module yutorina_id_stage(
  input wire clk, input wire rst, input wire stall, 
  input wire flush, input wire mode,
  input wire [`GprAddrBus] ex_fwd_addr, input wire [`WordDataBus] ex_fwd_out,
  input wire [`GprAddrBus] mem_fwd_addr, input wire [`WordDataBus] mem_fwd_out,
  input wire [`WordDataBus] gpr_r_data1, input wire [`WordDataBus] gpr_r_data2,
  output wire [`GprAddrBus] gpr_r_addr1, output wire [`GprAddrBus] gpr_r_addr2,
  input wire [`WordDataBus] spr_r_data,
  output wire br_taken, output wire [`WordAddrBus] br_addr,
  output wire ld_haz,
  input wire if_en_, input wire [`WordAddrBus] if_pc,
  input wire [`WordDataBus] if_insn,
  output reg id_en_, output reg [`WordAddrBus] id_pc,
  output reg [`AluOpBus] id_alu_op,
  output reg [`WordDataBus] id_alu_lhs, output reg [`WordDataBus] id_alu_rhs,
  output reg [`GprAddrBus] id_w_addr, output reg [`WordDataBus] id_w_data,
  output wire [`SprAddrBus] spr_r_addr,
  output reg id_gpr_we_, output reg [`ExpBus] id_exp_code,
  output reg [`MemOpBus] id_mem_op, output reg [`CtrlOpBus] id_ctrl_op);
  wire [`AluOpBus] alu_op;
  wire [`WordDataBus] alu_lhs;
  wire [`WordDataBus] alu_rhs;
  wire [`GprAddrBus] w_addr;
  wire [`WordDataBus] w_data;
  wire gpr_we_;
  wire [`MemOpBus] mem_op;
  wire [`CtrlOpBus] ctrl_op;
  wire [`ExpBus] exp_code;
  wire [`WordDataBus] r_data1
    = gpr_r_addr1 == mem_fwd_addr ? mem_fwd_out :
      gpr_r_addr1 == ex_fwd_addr ? ex_fwd_out : gpr_r_data1;
  wire [`WordDataBus] r_data2
    = gpr_r_addr2 == mem_fwd_addr ? mem_fwd_out :
      gpr_r_addr2 == ex_fwd_addr ? ex_fwd_out : gpr_r_data2;
  assign spr_r_addr = ctrl_op == `CTRL_LSR ? gpr_r_addr1 : `SPR_ZERO;
  assign ld_haz = mem_op == `MEM_R_W || mem_op == `MEM_R_H ||
                  mem_op == `MEM_R_B || mem_op == `MEM_R_HU ||
                  mem_op == `MEM_R_BU ? `TRUE : `FALSE;
  yutorina_insn_dec insn_dec(
    .mode (mode), .if_insn (if_insn), .if_pc (if_pc),
    .alu_op (alu_op), .alu_lhs (alu_lhs), .alu_rhs (alu_rhs),
    .gpr_r_data1 (r_data1), .gpr_r_data2 (r_data2),
    .gpr_r_addr1 (gpr_r_addr1), .gpr_r_addr2 (gpr_r_addr2),
    .spr_r_data (spr_r_data), .w_addr (w_addr), .w_data (w_data),
    .br_taken (br_taken), .br_addr (br_addr), .gpr_we_ (gpr_we_),
    .mem_op (mem_op), .ctrl_op (ctrl_op), .exp_code (exp_code));
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      id_en_      <= #1 `DISABLE_;
      id_pc       <= #1 `NULL;
      id_alu_op   <= #1 `ALU_NOP;
      id_alu_lhs  <= #1 `ZERO;
      id_alu_rhs  <= #1 `ZERO;
      id_w_addr   <= #1 `GPR_ZERO;
      id_w_data   <= #1 `ZERO;
      id_gpr_we_  <= #1 `DISABLE_;
      id_mem_op   <= #1 `MEM_NONE;
      id_ctrl_op  <= #1 `CTRL_NONE;
      id_exp_code <= #1 `EXP_NONE;
    end else begin
      id_en_ <= #1 if_en_;
      id_pc  <= #1 if_pc;
      if (flush == `ENABLE) begin
        id_alu_op   <= #1 `ALU_NOP;
        id_alu_lhs  <= #1 `ZERO;
        id_alu_rhs  <= #1 `ZERO;
        id_w_addr   <= #1 `NULL;
        id_w_data   <= #1 `ZERO;
        id_gpr_we_  <= #1 `DISABLE_;
        id_mem_op   <= #1 `MEM_NONE;
        id_ctrl_op  <= #1 `CTRL_NONE;
        id_exp_code <= #1 `EXP_NONE;
      end else if (if_en_ == `ENABLE_) begin
        id_alu_op   <= #1 alu_op;
        id_alu_lhs  <= #1 alu_lhs;
        id_alu_rhs  <= #1 alu_rhs;
        id_w_addr   <= #1 w_addr;
        id_w_data   <= #1 w_data;
        id_gpr_we_  <= #1 gpr_we_;
        id_mem_op   <= #1 mem_op;
        id_ctrl_op  <= #1 ctrl_op;
        id_exp_code <= #1 exp_code;
      end
    end
  end
endmodule
