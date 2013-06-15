`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "exp.h"
`include "gpr.h"
`include "spr.h"
`include "spm.h"

module yutorina_cpu(
  input wire clk, input wire clk_, input wire rst,
  input wire [`WordDataBus] i_r_data, input wire i_rdy_, output wire i_req_,
  output wire [`WordAddrBus] i_addr, output wire i_as_, output i_rw,
  output wire [`WordDataBus] i_w_data, input wire i_grnt_,
  input wire [`WordDataBus] d_r_data, input wire d_rdy_, output wire d_req_,
  output wire [`WordAddrBus] d_addr, output wire d_as_, output d_rw,
  output wire [`WordDataBus] d_w_data, input wire d_grnt_);
  wire stall = i_busy | d_busy;
  wire mode;
  wire i_busy;
  wire d_busy;
  wire br_taken;
  wire [`GprAddrBus] ex_fwd_addr;
  wire [`WordDataBus] ex_fwd_out;
  wire [`GprAddrBus] mem_fwd_addr;
  wire [`WordDataBus] mem_fwd_out;
  wire [`WordAddrBus] br_addr;
  wire [`WordAddrBus] if_pc;
  wire [`WordDataBus] if_insn;
  wire if_en_;
  wire id_en_;
  wire [`AluOpBus] id_alu_op;
  wire [`WordDataBus] id_alu_lhs;
  wire [`WordDataBus] id_alu_rhs;
  wire [`GprAddrBus] id_w_addr;
  wire [`WordDataBus] id_w_data;
  wire id_gpr_we_;
  wire [`MemOpBus] id_mem_op;
  wire [`CtrlOpBus] id_ctrl_op;
  wire [`ExpBus] id_exp_code;
  wire ex_en_;
  wire [`GprAddrBus] ex_w_addr;
  wire [`WordDataBus] ex_w_data;
  wire ex_gpr_we_;
  wire [`MemOpBus] ex_mem_op;
  wire [`CtrlOpBus] ex_ctrl_op;
  wire [`ExpBus] ex_exp_code;
  wire [`WordDataBus] ex_out;
  wire mem_en_;
  wire [`GprAddrBus] mem_w_addr;
  wire [`WordDataBus] mem_w_data;
  wire mem_gpr_we_;
  wire [`ExpBus] mem_exp_code;
  wire [`CtrlOpBus] mem_ctrl_op;
  wire [`WordDataBus] mem_out;
  wire [`SpmAddrBus] spm_i_addr;
  wire spm_i_as_;
  wire [`WordDataBus] spm_i_r_data;
  wire [`SpmAddrBus] spm_d_addr;
  wire spm_d_as_;
  wire spm_d_rw;
  wire [`WordDataBus] spm_d_w_data;
  wire [`WordDataBus] spm_d_r_data;
  wire [`GprAddrBus] gpr_r_addr1;
  wire [`GprAddrBus] gpr_r_addr2;
  wire [`WordDataBus] gpr_r_data1;
  wire [`WordDataBus] gpr_r_data2;
  wire gpr_we_ = `DISABLE_;
  yutorina_if_stage if_stage(
    .clk (clk), .rst (rst), .stall (stall), .busy (i_busy),
    .br_taken (br_taken), .br_addr (br_addr),
    .spm_r_data (spm_i_r_data), .spm_addr (spm_i_addr), .spm_as_ (spm_i_as_),
    .bus_r_data (i_r_data), .bus_w_data (i_w_data), .bus_addr (i_addr),
    .bus_rdy_ (i_rdy_), .bus_rw (i_rw), .bus_req_ (i_req_),
    .bus_as_ (i_as_), .bus_grnt_ (i_grnt_),
    .if_pc (if_pc), .if_insn (if_insn), .if_en_ (if_en_));
  yutorina_id_stage id_stage(
    .clk (clk), .rst (rst), .stall (stall), .mode (mode),
    .ex_fwd_out (ex_fwd_out), .ex_fwd_addr (ex_fwd_addr),
    .mem_fwd_out (mem_fwd_out), .mem_fwd_addr (mem_fwd_addr),
    .gpr_r_data1 (gpr_r_data1), .gpr_r_data2 (gpr_r_data2),
    .gpr_r_addr1 (gpr_r_addr1), .gpr_r_addr2 (gpr_r_addr2),
    .br_taken (br_taken), .br_addr (br_addr),
    .if_en_ (if_en_), .if_pc (if_pc), .if_insn (if_insn),
    .id_en_ (id_en_), .id_alu_op (id_alu_op),
    .id_alu_lhs (id_alu_lhs), .id_alu_rhs (id_alu_rhs),
    .id_w_addr (id_w_addr), .id_w_data (id_w_data), .id_gpr_we_ (id_gpr_we_),
    .id_mem_op (id_mem_op), .id_ctrl_op (id_ctrl_op),
    .id_exp_code (id_exp_code));
  yutorina_ex_stage ex_stage(
    .clk (clk), .rst (rst), .stall (stall),
    .id_en_ (id_en_), .id_alu_op (id_alu_op), .id_exp_code (id_exp_code),
    .id_alu_lhs (id_alu_lhs), .id_alu_rhs (id_alu_rhs),
    .id_w_addr (id_w_addr), .id_w_data (id_w_data), .id_gpr_we_ (id_gpr_we_),
    .id_mem_op (id_mem_op), .id_ctrl_op (id_ctrl_op),
    .ex_en_ (ex_en_), .ex_w_addr (ex_w_addr), .ex_w_data (ex_w_data),
    .ex_gpr_we_ (ex_gpr_we_), .ex_mem_op (ex_mem_op), .ex_ctrl_op (ex_ctrl_op),
    .ex_out (ex_out), .ex_exp_code (ex_exp_code),
    .fwd_out (ex_fwd_out), .fwd_addr (ex_fwd_addr));
  yutorina_mem_stage mem_stage(
    .clk (clk), .rst (rst), .stall (stall), .busy (d_busy),
    .ex_en_ (ex_en_), .ex_w_addr (ex_w_addr), .ex_w_data (ex_w_data),
    .ex_gpr_we_ (ex_gpr_we_), .ex_exp_code (ex_exp_code),
    .ex_mem_op (ex_mem_op), .ex_ctrl_op (ex_ctrl_op), .ex_out (ex_out),
    .mem_en_ (mem_en_), .mem_w_addr (mem_w_addr), .mem_w_data (mem_w_data),
    .mem_gpr_we_ (mem_gpr_we_), .mem_exp_code (mem_exp_code),
    .mem_ctrl_op (mem_ctrl_op), .mem_out (mem_out),
    .spm_r_data (spm_d_r_data), .spm_w_data (spm_d_w_data),
    .spm_addr (spm_d_addr), .spm_as_ (spm_d_as_), .spm_rw (spm_d_rw),
    .bus_r_data (d_r_data), .bus_w_data (d_w_data), .bus_rdy_ (d_rdy_),
    .bus_req_ (d_req_), .bus_addr (d_addr), .bus_as_ (d_as_),
    .bus_rw (d_rw), .bus_grnt_ (d_grnt_),
    .fwd_out (mem_fwd_out), .fwd_addr (mem_fwd_addr));
  yutorina_spm spm(
    .clk (clk_),
    .i_addr (spm_i_addr), .i_as_ (spm_i_as_), .i_r_data (spm_i_r_data),
    .d_addr (spm_d_addr), .d_as_ (spm_d_as_), .d_rw (spm_d_rw),
    .d_w_data (spm_d_w_data), .d_r_data (spm_d_r_data));
  yutorina_gpr gpr(
    .clk (clk), .rst (rst), 
    .r_addr1 (gpr_r_addr1), .r_data1 (gpr_r_data1),
    .r_addr2 (gpr_r_addr2), .r_data2 (gpr_r_data2),
    .we_ (mem_gpr_we_), .w_addr (mem_w_addr), .w_data (mem_out));
endmodule
