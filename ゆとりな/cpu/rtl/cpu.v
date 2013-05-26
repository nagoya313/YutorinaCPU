`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"
`include "spm.h"

`timescale 1ns/1ps

module yutorina_cpu(input wire clk, input wire clk_, input wire rst,
                    input wire [`WordDataBus] bus_rd_data,
                    input wire bus_rdy_, output wire bus_req_,
                    output wire [`WordAddrBus] bus_addr,
                    output wire bus_as_, output bus_rw,
                    output wire [`WordDataBus] bus_wr_data,
                    input wire bus_grnt_);
  reg [`WordAddrBus] pc;
  // はや〜いメモリ關聯
  wire [`SpmAddrBus] spm_i_addr;
  wire spm_i_as_;
  wire [`WordDataBus] spm_i_rd_data;
  wire [`SpmAddrBus] spm_d_addr;
  wire spm_d_as_;
  wire spm_d_rw;
  wire [`WordDataBus] spm_d_wr_data;
  wire [`WordDataBus] spm_d_rd_data;
  // はや〜いメモリ
  yutorina_spm spm(
    .clk (clk_),
    .i_addr (spm_i_addr), .i_as_ (spm_i_as_), .i_rd_data (spm_i_rd_data),
    .d_addr (spm_d_addr), .d_as_ (spm_d_as_), .d_rw (spm_d_rw),
    .d_wr_data (spm_d_wr_data), .d_rd_data (spm_d_rd_data));
endmodule
