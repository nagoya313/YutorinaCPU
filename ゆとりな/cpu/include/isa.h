`ifndef __YUTORINA_CPU_ISA_H__
`define __YUTORINA_CPU_ISA_H__

`define YUTORINA_REGISTER_NUM           32
`define YUTORINA_REGISTER_ADDRESS_WIDTH 5
`define YutorinaRegisterAddressBus      4:0

// 命令フォーマット
// R3形式
// 31:26：種類
// 25:21：對象レジスタ
// 20:16：左邊レジスタ
// 15:11：右邊レジスタ
// 10::0：オプションなど
// R2形式
// 31:26：種類
// 25:21：對象レジスタ
// 20:16：右邊レジスタ
// 15:0：即値など
// R1形式
// 31:26：種類
// 25:21：對象レジスタ
// 20:0：即値など
// R0形式
// 31:26：種類
// 25:0：即値など

`define YUTORINA_ISA_NOP 32'b0

`define YutorinaOpcodeBus    5:0
`define YutorinaOpcodeLocale 31:26

`define YutorinaResultRegisterLocale 25:21
`define YutorinaLeftRegisterLocale   20:16
`define YutorinaRightRegisterLocale  15:11

`define YutorinaImmediate2Locale 15:0
`define YutorinaImmediate1Locale 20:0
`define YutorinaImmediate0Locale 25:0
`define YutorinaFuncLocale       10:0

// 種類
// 算術命令
// 31:26=000000
// 25:21=對象レジスタ、20:16=左邊レジスタ、15:11=右邊レジスタ
// 10:0=オプション
`define YUTORINA_OPCODE_ARITHMETIC 6'b000000

`define YUTORINA_FUNC_ADD                    10'b0000000000
`define YUTORINA_FUNC_SUB                    10'b0000000001
`define YUTORINA_FUNC_AND                    10'b0000000010
`define YUTORINA_FUNC_OR                     10'b0000000011
`define YUTORINA_FUNC_XOR                    10'b0000000100
`define YUTORINA_FUNC_LOGICAL_SHIFT_LEFT     10'b0000000101
`define YUTORINA_FUNC_LOGICAL_SHIFT_RIGHT    10'b0000000110
`define YUTORINA_FUNC_SET_LESS_THAN          10'b0000000111
`define YUTORINA_FUNC_ARITHMETIC_SHIFT_LEFT  10'b0000001101
`define YUTORINA_FUNC_ARITHMETIC_SHIFT_RIGHT 10'b0000001110

// ロード命令
`define YUTORINA_OPCODE_LOAD_WORD      6'b000011
`define YUTORINA_OPCODE_LOAD_HALF_WORD 6'b000111
`define YUTORINA_OPCODE_LOAD_BYTE      6'b001011

// ストア命令
`define YUTORINA_OPCODE_STORE_WORD      6'b000010
`define YUTORINA_OPCODE_STORE_HALF_WORD 6'b000110
`define YUTORINA_OPCODE_STORE_BYTE      6'b001010

// 算術即値命令
`define YUTORINA_ARITHMETIC_IMMEDIATE_BIT        31
`define YutorinaArithmeticImmediateFuncLocale    29:26
`define YUTORINA_ARITHMETIC_IMMEDIATE_SIGNED_BIT 30

`define YUTORINA_OPCODE_ADD_IMMEDIATE                    6'b110000
`define YUTORINA_OPCODE_ADDU_IMMEDIATE                   6'b100000
`define YUTORINA_OPCODE_AND_IMMEDIATE                    6'b100010
`define YUTORINA_OPCODE_OR_IMMEDIATE                     6'b100011
`define YUTORINA_OPCODE_XOR_IMMEDIATE                    6'b100100
`define YUTORINA_OPCODE_LOGICAL_SHIFT_LEFT_IMMEDIATE     6'b100101
`define YUTORINA_OPCODE_LOGICAL_SHIFT_RIGHT_IMMEDIATE    6'b100110
`define YUTORINA_OPCODE_SET_LESS_THAN_IMMEDIATE          6'b100111
`define YUTORINA_OPCODE_ARITHMETIC_SHIFT_LEFT_IMMEDIATE  6'b101101
`define YUTORINA_OPCODE_ARITHMETIC_SHIFT_RIGHT_IMMEDIATE 6'b101110

// 分岐命令
`define YUTORINA_OPCODE_BRANCH_EQUAL     6'b010000
`define YUTORINA_OPCODE_BRANCH_NOT_EQUAL 6'b010001
`define YUTORINA_OPCODE_JUMP             6'b010010
`define YUTORINA_OPCODE_CALL             6'b010011
`define YUTORINA_OPCODE_JUMP_REGISTER    6'b010100
`define YUTORINA_OPCODE_CALL_REGISTER    6'b010101

// 特殊命令
`define YUTORINA_OPCODE_TRAP 6'b001100

// 特權命令
`define YUTORINA_OPCODE_READ_CONTROL_REGISTER  6'b111011
`define YUTPRINA_OPCODE_WRITE_CONTROL_REGISTER 6'b111010
`define YUTORINA_OPCODE_EXCEPTION_RETURN       6'b111100

// ALUオプコード
`define YutorinaALUOpcodeBus    3:0
`define YUTORINA_ALU_SIGNED_BIT 3

`define YUTORINA_ALU_OPCODE_ADD         3'b000
`define YUTORINA_ALU_OPCODE_SUB         3'b001
`define YUTORINA_ALU_OPCODE_AND         3'b010
`define YUTORINA_ALU_OPCODE_OR          3'b011
`define YUTORINA_ALU_OPCODE_XOR         3'b100
`define YUTORINA_ALU_OPCODE_LEFT_SHIFT  3'b101
`define YUTORINA_ALU_OPCODE_RIGHT_SHIFT 3'b110

`endif
