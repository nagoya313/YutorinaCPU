`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "bus.h"

`timescale 1ns/1ps

module yutorina_bus_addr_dec(input wire [`WordAddrBus] s_addr,
                             output wire s0_cs_, output wire s1_cs_,
                             output wire s2_cs_, output wire s3_cs_,
                             output wire s4_cs_, output wire s5_cs_,
                             output wire s6_cs_, output wire s7_cs_);
  wire [`BusSlaveIndexBus] s_index = s_addr[`BusSlaveIndexLocale];
  // アドレスに對應するスレーブの選擇
  assign s0_cs_ = s_index == `BUS_SLABE_0 ? `ENABLE_ : `DISABLE_;
  assign s1_cs_ = s_index == `BUS_SLABE_1 ? `ENABLE_ : `DISABLE_;
  assign s2_cs_ = s_index == `BUS_SLABE_2 ? `ENABLE_ : `DISABLE_;
  assign s3_cs_ = s_index == `BUS_SLABE_3 ? `ENABLE_ : `DISABLE_;
  assign s4_cs_ = s_index == `BUS_SLABE_4 ? `ENABLE_ : `DISABLE_;
  assign s5_cs_ = s_index == `BUS_SLABE_5 ? `ENABLE_ : `DISABLE_;
  assign s6_cs_ = s_index == `BUS_SLABE_6 ? `ENABLE_ : `DISABLE_;
  assign s7_cs_ = s_index == `BUS_SLABE_7 ? `ENABLE_ : `DISABLE_;
endmodule
