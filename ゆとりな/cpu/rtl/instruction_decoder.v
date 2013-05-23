`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"

`timescale 1ns/1ps

module yutorina_instruction_decoder(
  input wire [`YutorinaWordDataBus] instruction,
  output wire [`YutorinaALUOpcodeBus] alu_opcode,
  output wire [`YutorinaRegisterAddressBus] result_register_address,
  output wire [`YutorinaRegisterAddressBus] left_register_read_address,
  output wire [`YutorinaRegisterAddressBus] right_register_read_address,
  input wire [`YutorinaWordDataBus] left_register_read_data,
  input wire [`YutorinaWordDataBus] right_register_read_data,
  output wire [`YutorinaWordDataBus] lhs,
  output wire [`YutorinaWordDataBus] rhs,
  output wire register_write_enable_);
  wire [`YutorinaWordDataBus] left_register;
  wire [`YutorinaWordDataBus] right_register;
  wire [`YutorinaWordDataBus] immediate;
  // ALUオペコード
  // 算術命令と算術即値命令
  assign alu_opcode
    = instruction[`YutorinaOpcodeLocale] == `YUTORINA_OPCODE_ARITHMETIC ?
      instruction[`YutorinaALUOpcodeBus] : 
      instruction[`YUTORINA_ARITHMETIC_IMMEDIATE_BIT] ? 
      instruction[`YutorinaArithmeticImmediateFuncLocale] : 4'b0000;
  // 結果レジスタ
  assign result_register_address = instruction[`YutorinaResultRegisterLocale];
  // 左邊レジスタ
  assign left_register_read_address = instruction[`YutorinaLeftRegisterLocale];
  // 右邊レジスタ
  assign right_register_read_address
    = instruction[`YutorinaRightRegisterLocale];
  // 即値
  assign immediate
    = instruction[`YUTORINA_ARITHMETIC_IMMEDIATE_BIT] ?
      instruction[`YUTORINA_ARITHMETIC_IMMEDIATE_SIGNED_BIT] ?
      {{16{instruction[15]}}, instruction[15:0]} :
      {{16{1'b0}}, instruction[15:0]} : 
      `YUTORINA_WORD_DATA_WIDTH'h0;
  // ALUで使ふ値
  assign lhs
    = ((instruction[`YutorinaOpcodeLocale] == `YUTORINA_OPCODE_ARITHMETIC) ||
       (instruction[`YUTORINA_ARITHMETIC_IMMEDIATE_BIT])) ?
      left_register_read_data : `YUTORINA_WORD_DATA_WIDTH'h0;
  assign rhs
    = instruction[`YutorinaOpcodeLocale] == `YUTORINA_OPCODE_ARITHMETIC ?
      right_register_read_data : 
      instruction[`YUTORINA_ARITHMETIC_IMMEDIATE_BIT] ?
      immediate :
      `YUTORINA_WORD_DATA_WIDTH'h0;
  // 汎用レジスタに書く？
  assign register_write_enable_
    = ((instruction[`YutorinaOpcodeLocale] == `YUTORINA_OPCODE_ARITHMETIC) ||
       (instruction[`YUTORINA_ARITHMETIC_IMMEDIATE_BIT])) ?
      `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
endmodule
