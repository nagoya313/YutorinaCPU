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
        `ALU_ADD: begin
          alu = lhs + rhs;
        end `ALU_SUB: begin
          alu = lhs - rhs;
        end `ALU_AND: begin
          alu = lhs & rhs;
        end `ALU_OR: begin
          alu = lhs | rhs;
        end `ALU_XOR: begin
          alu = lhs ^ rhs;
        end `ALU_NOR: begin
          alu = !(lhs | rhs);
        end `ALU_SLTU: begin
          alu = lhs < rhs ? `ONE : `ZERO;
        end `ALU_SLT: begin
          alu = s_lhs < s_rhs ? `ONE : `ZERO;
        end `ALU_SLL: begin
          alu = lhs << rhs;
        end `ALU_SLR: begin
          alu = lhs >> rhs;
        end `ALU_SAR: begin
          alu = s_lhs >>> s_rhs;
        end
      endcase
    end
  endfunction
  assign out = alu(op, lhs, rhs);
endmodule
