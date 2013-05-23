`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "bus.h"

module yutorina_bus_address_decoder(
  input wire [`YutorinaWordAddressBus] slave_address,
  output wire slave0_chip_select_,
  output wire slave1_chip_select_,
  output wire slave2_chip_select_,
  output wire slave3_chip_select_,
  output wire slave4_chip_select_,
  output wire slave5_chip_select_,
  output wire slave6_chip_select_,
  output wire slave7_chip_select_);
  wire [`YutorinaBusSlaveIndexBus] slave_index
    = slave_address[`YutorinaBysSlaveIndexLocale];
  // アドレスに對應するスレーブの選擇
  assign slave0_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_0 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign slave1_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_1 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign slave2_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_2 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign slave3_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_3 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign slave4_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_4 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign slave5_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_5 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign slave6_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_6 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign slave7_chip_select_
    = slave_index == `YUTORINA_BUS_SLABE_7 ? 
                     `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
endmodule
