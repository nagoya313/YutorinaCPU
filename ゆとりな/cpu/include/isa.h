`ifndef __YUTORINA_CPU_ISA_H__
`define __YUTORINA_CPU_ISA_H__

`define ISA_NOP 32'b0

`define JPcLocale 29:24

// オペコード
`define OpBus    5:0
`define OpLocale 31:26

// レジスタ
`define RaLocale 25:21
`define RbLocale 20:16
`define RcLocale 15:11

// 即値
`define ImmBus     15:0
`define ImmLocale  15:0
`define JImmBus    25:0
`define JImmLocale 25:0

// 機能コード
`define FuncBus    5:0
`define FuncLocale 5:0

// 種類
// 算術・論理演算命令
`define OP_AL 6'b000000

// 機能コード
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

// ロード命令
`define OP_LW  6'b001000
`define OP_LHU 6'b001001
`define OP_LBU 6'b001010
`define OP_LH  6'b001011
`define OP_LB  6'b001100            

// ストア命令
`define OP_SW 6'b000001
`define OP_SH 6'b000010
`define OP_SB 6'b000011

// 算術即値命令
`define OP_ADDIU 6'b010000
`define OP_ANDI  6'b010010
`define OP_ORI   6'b010011
`define OP_XORI  6'b010100
`define OP_SLTUI 6'b010110
`define OP_SLTI  6'b011111
`define OP_ADDI  6'b011000
`define OP_ADDUI 6'b110000

// 分岐命令
// 比較命令
`define OP_BEQ 6'b100000
`define OP_BNE 6'b101000
// 飛翔命令
`define OP_JMP  6'b000100
`define OP_CALL 6'b000101
// 飛翔レジスタ命令
`define OP_JMPR  6'b000110

// 機能コード
`define FUNC_JMP  6'b000000
`define FUNC_CALL 6'b000001

// 特殊命令
`define OP_SP 6'b111110

// 機能コード
`define FUNC_TRAP 6'b000000
`define FUNC_RET  6'b000001

// 特權命令
`define OP_KER 6'b111111

// 機能コード
`define FUNC_LSR  6'b000010
`define FUNC_SSR  6'b000001
`define FUNC_ERET 6'b000000

// ALUオプコード
`define AluOpBus    4:0
`define AluOpLocale 4:0

`define ALU_OP_NOP  4'b0000
`define ALU_OP_ADD  4'b0000
`define ALU_OP_SUB  4'b0001
`define ALU_OP_AND  4'b0010
`define ALU_OP_OR   4'b0011
`define ALU_OP_XOR  4'b0100
`define ALU_OP_NOR  4'b0101
`define ALU_OP_SLTU 4'b0110
`define ALU_OP_SLT  4'b0111
`define ALU_OP_SLL  4'b1000
`define ALU_OP_SLR  4'b1001
`define ALU_OP_SAR  4'b1010
`define ALU_OP_MUL  4'b1011
`define ALU_OP_MULU 4'b1100
`define ALU_OP_DIV  4'b1101
`define ALU_OP_DIVU 4'b1110

`endif
