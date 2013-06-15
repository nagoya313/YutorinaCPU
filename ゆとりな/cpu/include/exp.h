`ifndef __YUTORINA_CPU_EXP_H__
`define __YUTORINA_CPU_EXP_H__

`define ExpBus 4:0

`define EXP_NONE             5'b00000
`define EXP_INVALID_INSN     5'b00001
`define EXP_LOAD_MISS_ALIGN  5'b00010
`define EXP_STORE_MISS_ALIGN 5'b00011
`define EXP_TRAP             5'b00100
`define EXP_PRV_INSN         5'b00101

`endif
