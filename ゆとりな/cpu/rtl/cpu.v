`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "spm.h"

`timescale 1ns/1ps

module yutorina_cpu(input wire clock, input wire clock_, input wire reset);
  // SPM關聯
  wire [`YutorinaSpmAddressBus] spm_instruction_address;
  wire spm_instruction_address_strobe_;
  wire spm_instruction_read_write;
  wire [`YutorinaWordDataBus] spm_instruction_write_data;
  wire [`YutorinaWordDataBus] spm_instruction_read_data;
  wire [`YutorinaSpmAddressBus] spm_data_address;
  wire spm_data_address_strobe_;
  wire spm_data_read_write;
  wire [`YutorinaWordDataBus] spm_data_write_data;
  wire [`YutorinaWordDataBus] spm_data_read_data;
  // レジスタ關聯
  wire [`YutorinaRegisterAddressBus] register_read_address0;
  wire [`YutorinaWordDataBus] register_read_data0;
  wire [`YutorinaRegisterAddressBus] register_read_address1;
  wire [`YutorinaWordDataBus] register_read_data1;
  wire register_write_enable_;
  wire [`YutorinaRegisterAddressBus] register_write_address;
  wire [`YutorinaWordDataBus] register_write_data;
  // 命令關聯
  wire [`YutorinaALUOpcodeBus] alu_opcode;
  wire [`YutorinaWordDataBus] instruction;
  wire [`YutorinaWordDataBus] lhs;
  wire [`YutorinaWordDataBus] rhs;
  // 命令を讀む
  yutorina_instruction_fetch instruction_fetch(
    .clock (clock), .reset(reset),
    .spm_read_data (spm_instruction_read_data),
    .spm_read_addreess (spm_instruction_address),
    .instruction (instruction));
  // 命令を解析
  yutorina_instruction_decoder instruction_decoder(
    .instruction (instruction), .alu_opcode (alu_opcode),
    .result_register_address (register_write_address), 
    .left_register_read_address (register_read_address0), 
    .right_register_read_address (register_read_address1),
    .left_register_read_data (register_read_data0),
    .right_register_read_data (register_read_data1),
    .lhs(lhs), .rhs(rhs),
    .register_write_enable_ (register_write_enable_));
  // ALU
  yutorina_alu alu(.opcode (alu_opcode), .result(register_write_data),
                   .lhs (lhs), .rhs (rhs));
  // はや〜いメモリ
  yutorina_spm spm(
    .clock (clock_),
    .instruction_address (spm_instruction_address),
    .instruction_address_strobe_ (spm_instruction_address_strobe_),
    .instruction_read_write (spm_instruction_read_write),
    .instruction_write_data (spm_instruction_write_data),
    .instruction_read_data (spm_instruction_read_data),
    .data_address (spm_data_address),
    .data_address_strobe_ (spm_data_address_strobe_),
    .data_read_write (spm_data_read_write),
    .data_write_data (spm_data_write_data),
    .data_read_data (spm_data_read_data));
  // 汎用レジスタ
  yutorina_gpr gpr(.clock (clock), .reset (reset),
                   .read_address0 (register_read_address0),
                   .read_data0 (register_read_data0),
                   .read_address1 (register_read_address1),
                   .read_data1 (register_read_data1),
                   .write_enable_ (register_write_enable_),
                   .write_address (register_write_address), 
                   .write_data (register_write_data));
endmodule
