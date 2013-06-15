`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "exp.h"
`include "gpr.h"

module yutorina_ex_stage(
  input wire clk, input wire rst, input wire stall,
  input wire id_en_, input wire [`AluOpBus] id_alu_op,
  input wire [`WordDataBus] id_alu_lhs, input wire [`WordDataBus] id_alu_rhs,
  input wire [`GprAddrBus] id_w_addr, input wire [`WordDataBus] id_w_data,
  input wire id_gpr_we_, input wire [`ExpBus] id_exp_code,
  input wire [`MemOpBus] id_mem_op, input wire [`CtrlOpBus] id_ctrl_op,
  output reg ex_en_,
  output reg [`GprAddrBus] ex_w_addr, output reg [`WordDataBus] ex_w_data,
  output reg ex_gpr_we_, output reg [`ExpBus] ex_exp_code,
  output reg [`MemOpBus] ex_mem_op, output reg [`CtrlOpBus] ex_ctrl_op,
  output reg [`WordDataBus] ex_out,
  output wire [`GprAddrBus] fwd_addr, output wire [`WordDataBus] fwd_out);
  wire [`WordDataBus] alu_out;
  assign fwd_out = alu_out;
  assign fwd_addr = id_w_addr;
  yutorina_alu alu(.op (id_alu_op), 
                   .lhs (id_alu_lhs), .rhs (id_alu_rhs), .out (alu_out));
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      ex_en_      <= #1 `DISABLE_;
      ex_w_addr   <= #1 `GPR_ZERO;
      ex_w_data   <= #1 `NULL;
      ex_gpr_we_  <= #1 `DISABLE_;
      ex_exp_code <= #1 `EXP_NONE;
      ex_mem_op   <= #1 `MEM_NONE;
      ex_ctrl_op  <= #1 `CTRL_NONE;
      ex_out      <= #1 `ZERO;
    end else begin
      if (id_en_ == `ENABLE_) begin
        ex_en_      <= #1 id_en_;
        ex_w_addr   <= #1 id_w_addr;
        ex_w_data   <= #1 id_w_data;
        ex_gpr_we_  <= #1 id_gpr_we_;
        ex_exp_code <= #1 id_exp_code;
        ex_mem_op   <= #1 id_mem_op;
        ex_ctrl_op  <= #1 id_ctrl_op;
        ex_out      <= #1 alu_out;
      end else begin
        ex_en_ <= #1 `DISABLE_;
      end
    end
  end
endmodule
