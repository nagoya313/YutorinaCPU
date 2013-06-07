`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"

module yutorina_alu(
  input wire [`AluOpBus] op,
  input wire [`WordDataBus] lhs, input wire [`WordDataBus] rhs,
  output wire [`WordDataBus] out);
  function [`WordDataBus] alu;
    input [`AluOpBus] op;
    input [`WordDataBus] lhs;
    input [`WordDataBus] rhs;
    reg signed [`WordDataBus] s_lhs;
    reg signed [`WordDataBus] s_rhs;
    begin
      s_lhs = $signed(lhs);
      s_rhs = $signed(rhs);
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
          alu = lhs < rhs ? `ONE : `ZERO;
        end `ALU_OP_SLT: begin
          alu = s_lhs < s_rhs ? `ONE : `ZERO;
        end `ALU_OP_SLL: begin
          alu = lhs << rhs;
        end `ALU_OP_SLR: begin
          alu = lhs >> rhs;
        end `ALU_OP_SAR: begin
          alu = s_lhs >>> s_rhs;
        end
      endcase
    end
  endfunction
  assign out = alu(op, lhs, rhs);
endmodule
