`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"

`timescale 1ns/1ps

module yutorina_alu(
  input wire [`AluOpBus] op, input wire [`WordDataBus] lhs,
  input wire [`WordDataBus] rhs, output wire [`WordDataBus] ret);
  function [`WordDataBus] alu;
    input [`AluOpBus] op;
    input [`WordDataBus] lhs;
    input [`WordDataBus] rhs;
    begin
      case (op)
        `ALU_OP_ADD: begin
          alu = lhs + rhs;
        end `ALU_OP_SUB: begin
          alu = lhs - rhs;
        end `ALU_OP_AND: begin
          alu = lhs & rhs;
        end `ALU_OP_OR: begin
          alu = lhs | rhs;
        end `ALU_OP_XOR: begin
          alu = lhs ^ rhs;
        end `ALU_OP_NOR: begin
          alu = !(lhs | rhs);
        end `ALU_OP_SLTU: begin
          alu = lhs < rhs ? `WORD_DATA_W'h1 : `WORD_DATA_W'h0;
        end `ALU_OP_SLL: begin
          alu = lhs << rhs;
        end `ALU_OP_SLR: begin
          alu = lhs >> rhs;
        end
        // ここから下未實裝命令
      endcase
    end
  endfunction
  assign ret = alu(op, lhs, rhs);
endmodule
