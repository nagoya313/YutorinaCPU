`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "spm.h"

`timescale 1ns/1ps

module yutorina_instruction_fetch(
  input wire clock, input wire reset,
  input wire [`YutorinaWordDataBus] spm_read_data,
  output wire [`YutorinaSpmAddressBus] spm_read_addreess,
  output reg [`YutorinaWordAddressBus] program_counter,
  output reg [`YutorinaWordDataBus] instruction);
  assign spm_read_addreess = program_counter[`YutorinaSpmAddressBus];
  always @(posedge clock or `YUTORINA_RESET_EDGE reset) begin
    if (reset == `YUTORINA_RESET_ENABLE) begin
      program_counter <= #1 `YUTORINA_WORD_ADDRESS_WIDTH'h0;
      instruction <= #1 `YUTORINA_ISA_NOP;
    end else begin
      program_counter <= #1 program_counter + 1;
      instruction <= #1 spm_read_data;
    end
  end
endmodule
