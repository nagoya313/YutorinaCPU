`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "bus.h"

`timescale 1ns/1ps

module yutorina_bus_master_mux(
  // マスタ0
  input wire [`WordAddrBus] m0_addr, input wire m0_as_, input wire m0_rw,
  input wire [`WordDataBus] m0_wr_data, input wire m0_grnt_,
  // マスタ1
  input wire [`WordAddrBus] m1_addr, input wire m1_as_, input wire m1_rw,
  input wire [`WordDataBus] m1_wr_data, input wire m1_grnt_,
  // マスタ2
  input wire [`WordAddrBus] m2_addr, input wire m2_as_, input wire m2_rw,
  input wire [`WordDataBus] m2_wr_data, input wire m2_grnt_,
  // マスタ3
  input wire [`WordAddrBus] m3_addr, input wire m3_as_, input wire m3_rw,
  input wire [`WordDataBus] m3_wr_data, input wire m3_grnt_,
  // 奴隷
  output wire [`WordAddrBus] s_addr, output wire s_as_, output wire s_rw,
  output wire [`WordDataBus] s_wr_data);
  // バス權を持つてゐるマスタの選擇
  assign s_addr
    = m0_grnt_ == `ENABLE_ ? m0_addr :
      m1_grnt_ == `ENABLE_ ? m1_addr :
      m2_grnt_ == `ENABLE_ ? m2_addr :
      m3_grnt_ == `ENABLE_ ? m3_addr :
      `WORD_ADDR_W'h0;
  assign s_as_ 
    = m0_grnt_ == `ENABLE_ ? m0_as_ :
      m1_grnt_ == `ENABLE_ ? m1_as_ :
      m2_grnt_ == `ENABLE_ ? m2_as_ :
      m3_grnt_ == `ENABLE_ ? m3_as_ :
      `DISABLE_;
  assign s_rw
    = m0_grnt_ == `ENABLE_ ? m0_rw :
      m1_grnt_ == `ENABLE_ ? m1_rw :
      m2_grnt_ == `ENABLE_ ? m2_rw :
      m3_grnt_ == `ENABLE_ ? m3_rw :
      `READ;
  assign s_wr_data 
    = m0_grnt_ == `ENABLE_ ? m0_wr_data :
      m1_grnt_ == `ENABLE_ ? m1_wr_data :
      m2_grnt_ == `ENABLE_ ? m2_wr_data :
      m3_grnt_ == `ENABLE_ ? m3_wr_data :
      `WORD_DATA_W'h0;
endmodule
