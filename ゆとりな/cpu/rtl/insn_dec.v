`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"
`include "gpr.h"
`include "exp.h"
`include "spr.h"
                  
`define InsnBus 4+32+32+32+5+5+5+1+30+1+4+2+5-1:0

module yutorina_insn_dec(
  input wire mode,
  input wire [`WordDataBus] if_insn, input wire [`WordAddrBus] if_pc,
  output wire [`AluOpBus] alu_op,
  output wire [`WordDataBus] alu_lhs, output wire [`WordDataBus] alu_rhs,
  input wire [`WordDataBus] gpr_r_data1, input wire [`WordDataBus] gpr_r_data2,
  output wire [`GprAddrBus] gpr_r_addr1, output wire [`GprAddrBus] gpr_r_addr2,
  input wire [`WordDataBus] spr_r_data,
  output wire [`GprAddrBus] w_addr, output wire [`WordDataBus] w_data,
  output wire br_taken, output wire [`WordAddrBus] br_addr,
  output wire gpr_we_, output wire [`ExpBus] exp_code,
  output wire [`MemOpBus] mem_op, output wire [`CtrlOpBus] ctrl_op);
  function [`InsnBus] insn_dec;
    input mod;
    input [`WordDataBus] insn;
    input [`WordAddrBus] pc;
    input [`WordDataBus] gpr_r_data1;
    input [`WordDataBus] gpr_r_data2;
    input [`WordDataBus] spr_r_data;
    reg [`OpBus] op;
    reg [`AluOpBus] alu;
    reg [`FuncBus] func;
    reg [`ImmBus] imm;
    reg [`WordDataBus] imm32;
    reg [`WordAddrBus] s_imm30;
    reg [`WordDataBus] s_imm32;
    reg [`WordDataBus] u_imm32;
    reg [`WordDataBus] r_imm32;
    reg [`GprAddrBus] ra;
    reg [`GprAddrBus] rb;
    reg [`GprAddrBus] rc;
    reg [`JImmBus] j_imm;
    reg [`ShamtBus] shamt;
    reg [`InsnBus] err;
    reg [`InsnBus] prv_err;
    reg [`WordAddrBus] b_addr;
    reg [`WordAddrBus] j_addr;
    begin
      op      = if_insn[`OpLocale];
      func    = if_insn[`FuncLocale];
      alu     = if_insn[`AluOpLocale];
      ra      = if_insn[`RaLocale];
      rb      = if_insn[`RbLocale];
      rc      = if_insn[`RcLocale];
      imm     = if_insn[`ImmLocale];
      imm32   = {{16{1'b0}}, imm};
      s_imm30 = {{14{imm[15]}}, imm};
      s_imm32 = {{16{imm[15]}}, imm};
      u_imm32 = {imm, {16{1'b0}}};
      r_imm32 =  {{27{1'b0}}, rc};
      j_imm   = if_insn[`JImmLocale];
      shamt   = if_insn[`ShamtLocale];
      err     =  {`ALU_NOP, `ZERO, `ZERO, `ZERO,
                  `GPR_ZERO, `GPR_ZERO, `GPR_ZERO, `FALSE, `NULL,
                  `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_INVALID_INSN};
      prv_err =  {`ALU_NOP, `ZERO, `ZERO, `ZERO,
                  `GPR_ZERO, `GPR_ZERO, `GPR_ZERO, `FALSE, `NULL,
                  `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_PRV_INSN};
      b_addr = pc + s_imm32;
      j_addr  = {pc[`JLocale], j_imm};
      case (op)
        `OP_AL: begin
          case (func)
            `FUNC_ADD: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_ADD, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_SUB: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_SUB, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_AND: begin
              if (shamt == `SHAMT_ZERO) begin  
                insn_dec = {`ALU_AND, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_OR: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_OR, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_XOR: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_XOR, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_NOR: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_NOR, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_SLTU: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_SLTU, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_SLT: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_SLT, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_SLL: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_SLL, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else if (shamt == `SHAMT_IMM) begin
                insn_dec = {`ALU_SLR, gpr_r_data1, r_imm32, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_SLR: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_SLR, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else if (shamt == `SHAMT_IMM) begin
                insn_dec = {`ALU_SLR, gpr_r_data1, r_imm32, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end `FUNC_SAR: begin
              if (shamt == `SHAMT_ZERO) begin
                insn_dec = {`ALU_SAR, gpr_r_data1, gpr_r_data2, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else if (shamt == `SHAMT_IMM) begin
                insn_dec = {`ALU_SLR, gpr_r_data1, r_imm32, `ZERO,
                            rb, rc, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = err;
              end
            end default: begin
              insn_dec = err;
            end
          endcase
        end `OP_LW: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_R_W, `CTRL_NONE, `EXP_NONE};
        end `OP_LH: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_R_H, `CTRL_NONE, `EXP_NONE};
        end `OP_LB: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_R_B, `CTRL_NONE, `EXP_NONE};
        end `OP_LHU: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_R_HU, `CTRL_NONE, `EXP_NONE};
        end `OP_LBU: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_R_BU, `CTRL_NONE, `EXP_NONE};
        end `OP_SW: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `DISABLE_, `MEM_W_W, `CTRL_NONE, `EXP_NONE};
        end `OP_SH: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `DISABLE_, `MEM_W_H, `CTRL_NONE, `EXP_NONE};
        end `OP_SB: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `DISABLE_, `MEM_W_B, `CTRL_NONE, `EXP_NONE};
        end `OP_ADDIU: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_ANDI: begin
          insn_dec = {`ALU_AND, gpr_r_data1, imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_ORI: begin
          insn_dec = {`ALU_OR, gpr_r_data1, imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_XORI: begin
          insn_dec = {`ALU_XOR, gpr_r_data1, imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_SLTUI: begin
          insn_dec = {`ALU_SLTU, gpr_r_data1, imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_SLTI: begin
          insn_dec = {`ALU_SLT, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_ADDI: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, s_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_ADDUI: begin
          insn_dec = {`ALU_ADD, gpr_r_data1, u_imm32, `ZERO,
                      rb, `GPR_ZERO, ra, `FALSE, `NULL,
                      `ENABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_BEQ: begin
          insn_dec = {`ALU_NOP, `ZERO, `ZERO, `ZERO, rb, rc, `GPR_ZERO,
                      gpr_r_data1 == gpr_r_data2 ? `TRUE : `FALSE, b_addr,
                      `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_BNE: begin
          insn_dec = {`ALU_NOP, `ZERO, `ZERO, `ZERO, rb, rc, `GPR_ZERO,
                      gpr_r_data1 != gpr_r_data2 ? `TRUE : `FALSE, b_addr,
                      `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_JMP: begin
          insn_dec = {`ALU_NOP, `ZERO, `ZERO, `ZERO,
                      `GPR_ZERO, `GPR_ZERO, `GPR_ZERO, `TRUE, j_addr,
                      `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_CALL: begin
          insn_dec = {`ALU_NOP, `ZERO, `ZERO, pc + 2'b10,
                      `GPR_ZERO, `GPR_ZERO, `GPR_RA, `TRUE, j_addr,
                      `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
        end `OP_JMPR: begin
          case (func)
            `FUNC_JMP: begin
              insn_dec = {`ALU_NOP, `ZERO, `ZERO, `ZERO,
                          ra, `GPR_ZERO, `GPR_ZERO, `TRUE,
                          gpr_r_data1[`WordAddrLocale],
                          `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
            end `FUNC_CALL: begin
              insn_dec = {`ALU_NOP, `ZERO, `ZERO, pc + 2'b10,
                          ra, `GPR_ZERO, `GPR_RA, `TRUE,
                          gpr_r_data1[`WordAddrLocale],
                          `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
            end default: begin
              insn_dec = err;
            end
          endcase
        end `OP_SP: begin
          case (func)
            `FUNC_TRAP: begin
              insn_dec = {`ALU_NOP, `ZERO, `ZERO, `ZERO,
                          `GPR_ZERO, `GPR_ZERO, `GPR_ZERO, `FALSE, `NULL,
                          `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_TRAP};
            end default: begin
              insn_dec = err;
            end
          endcase
        end `OP_KER: begin
          case (func)
            `FUNC_LSR: begin
              if (mod == `MODE_KERNEL) begin
                insn_dec = {`ALU_NOP, spr_r_data, `ZERO, `ZERO,
                            rb, `GPR_ZERO, ra, `FALSE, `NULL,
                            `ENABLE_, `MEM_NONE, `CTRL_LSR, `EXP_NONE};
              end else begin
                insn_dec = prv_err;
              end
            end `FUNC_SSR: begin
              if (mod == `MODE_KERNEL) begin
                insn_dec = {`ALU_NOP, `ZERO, `ZERO, gpr_r_data1,
                            ra, `GPR_ZERO, rb, `FALSE, `NULL,
                            `DISABLE_, `MEM_NONE, `CTRL_SSR, `EXP_NONE};
              end else begin
                insn_dec = prv_err;
              end
            end `FUNC_ERET: begin
              if (mod == `MODE_KERNEL) begin
                insn_dec = {`ALU_NOP, `ZERO, `ZERO, `ZERO,
                            `GPR_ZERO, `GPR_ZERO, `GPR_ZERO, `TRUE, `NULL,
                            `DISABLE_, `MEM_NONE, `CTRL_NONE, `EXP_NONE};
              end else begin
                insn_dec = prv_err;
              end
            end default: begin
              insn_dec = err;
            end
          endcase
        end default: begin
          insn_dec = err;
        end
      endcase
    end
  endfunction
  assign {alu_op, alu_lhs, alu_rhs, w_data, gpr_r_addr1, gpr_r_addr2,
          w_addr, br_taken, br_addr, gpr_we_, mem_op, ctrl_op, exp_code}
            = insn_dec(mode, if_insn, if_pc,
                       gpr_r_data1, gpr_r_data2, spr_r_data);
endmodule
