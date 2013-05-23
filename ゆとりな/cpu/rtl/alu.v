`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"

`timescale 1ns/1ps

module yutorina_alu(input [`YutorinaALUOpcodeBus] opcode,
                    input wire [`YutorinaWordDataBus] lhs,
                    input wire [`YutorinaWordDataBus] rhs,
                    output wire [`YutorinaWordDataBus] result);
   assign result
     = opcode == `YUTORINA_ALU_OPCODE_ADD         ? lhs + rhs :
       opcode == `YUTORINA_ALU_OPCODE_SUB         ? lhs - rhs :
       opcode == `YUTORINA_ALU_OPCODE_AND         ? lhs & rhs :
       opcode == `YUTORINA_ALU_OPCODE_OR          ? lhs | rhs :
       opcode == `YUTORINA_ALU_OPCODE_XOR         ? lhs ^ rhs :
       opcode == `YUTORINA_ALU_OPCODE_LEFT_SHIFT  ? lhs << rhs :
       opcode == `YUTORINA_ALU_OPCODE_RIGHT_SHIFT ? lhs >> rhs :
       lhs < rhs ? `YUTORINA_WORD_DATA_WIDTH'h1 : `YUTORINA_WORD_DATA_WIDTH'h0;
endmodule
