`ifndef __YUTORINA_CPU_ISA_H__
`define __YUTORINA_CPU_ISA_H__

`define ISA_NOP 32'b0

`define JPcLocale 29:24

`define OpBus    5:0
`define OpLocale 31:26

`define RaLocale 25:21
`define RbLocale 20:16
`define RcLocale 15:11

`define ImmBus     15:0
`define ImmLocale  15:0
`define JImmBus    25:0
`define JImmLocale 25:0

`define JLocale 31:26

`define FuncBus    5:0
`define FuncLocale 5:0

`define OP_AL 6'b000000

`define FUNC_NOP  6'b000000
`define FUNC_ADD  6'b000000
`define FUNC_SUB  6'b000001
`define FUNC_AND  6'b000010
`define FUNC_OR   6'b000011
`define FUNC_XOR  6'b000100
`define FUNC_NOR  6'b000101
`define FUNC_SLTU 6'b000110
`define FUNC_SLT  6'b000111
`define FUNC_SLL  6'b001000
`define FUNC_SLR  6'b001001
`define FUNC_SAR  6'b001010
`define FUNC_MUL  6'b001011
`define FUNC_MULU 6'b001100
`define FUNC_DIV  6'b001101
`define FUNC_DIVU 6'b001110

`define ShamtBus    4:0
`define ShamtLocale 10:6
`define SHAMT_ZERO  5'b00000
`define SHAMT_IMM   5'b10000

`define OP_LW  6'b001000
`define OP_LHU 6'b001001
`define OP_LBU 6'b001010
`define OP_LH  6'b001011
`define OP_LB  6'b001100            

`define OP_SW 6'b000001
`define OP_SH 6'b000010
`define OP_SB 6'b000011

`define OP_ADDIU 6'b010000
`define OP_ANDI  6'b010010
`define OP_ORI   6'b010011
`define OP_XORI  6'b010100
`define OP_SLTUI 6'b010110
`define OP_SLTI  6'b011111
`define OP_ADDI  6'b011000
`define OP_ADDUI 6'b110000

`define OP_BEQ   6'b100000
`define OP_BNE   6'b101000
`define OP_JMP   6'b000100
`define OP_CALL  6'b000101
`define OP_JMPR  6'b000110

`define FUNC_JMP  6'b000000
`define FUNC_CALL 6'b000001

`define OP_SP 6'b111110

`define FUNC_TRAP 6'b000000

`define OP_KER 6'b111111

`define FUNC_LSR  6'b000010
`define FUNC_SSR  6'b000001
`define FUNC_ERET 6'b000000

`define AluOpBus    4:0
`define AluOpLocale 4:0

`define ALU_NOP  4'b0000
`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_AND  4'b0010
`define ALU_OR   4'b0011
`define ALU_XOR  4'b0100
`define ALU_NOR  4'b0101
`define ALU_SLTU 4'b0110
`define ALU_SLT  4'b0111
`define ALU_SLL  4'b1000
`define ALU_SLR  4'b1001
`define ALU_SAR  4'b1010
`define ALU_MUL  4'b1011
`define ALU_MULU 4'b1100
`define ALU_DIV  4'b1101
`define ALU_DIVU 4'b1110

`endif
