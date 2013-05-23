`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "bus.h"

module bus_slave_multiplexer(
  input wire slave0_chip_select_,
  input wire [`YutorinaWordDataBus] slave0_read_data,
  input wire slave0_ready_,
  input wire slave1_chip_select_,
  input wire [`YutorinaWordDataBus] slave1_read_data,
  input wire slave1_ready_,
  input wire slave2_chip_select_,
  input wire [`YutorinaWordDataBus] slave2_read_data,
  input wire slave2_ready_,
  input wire slave3_chip_select_,
  input wire [`YutorinaWordDataBus] slave3_read_data,
  input wire slave3_ready_,
  input wire slave4_chip_select_,
  input wire [`YutorinaWordDataBus] slave4_read_data,
  input wire slave4_ready_,
  input wire slave5_chip_select_,
  input wire [`YutorinaWordDataBus] slave5_read_data,
  input wire slave5_ready_,
  input wire slave6_chip_select_,
  input wire [`YutorinaWordDataBus] slave6_read_data,
  input wire slave6_ready_,
  input wire slave7_chip_select_,
  input wire [`YutorinaWordDataBus] slave7_read_data,
  input wire slave7_ready_,
  output wire [`YutorinaWordDataBus] master_read_data,
  output wire master_ready_);
  // チップセレクトに對應するスレーブの選擇
  assign master_read_data 
    = slave0_chip_select_ == `YUTORINA_ENABLE_ ? slave0_read_data :
      slave1_chip_select_ == `YUTORINA_ENABLE_ ? slave1_read_data :
      slave2_chip_select_ == `YUTORINA_ENABLE_ ? slave2_read_data :
      slave3_chip_select_ == `YUTORINA_ENABLE_ ? slave3_read_data :
      slave4_chip_select_ == `YUTORINA_ENABLE_ ? slave4_read_data :
      slave5_chip_select_ == `YUTORINA_ENABLE_ ? slave5_read_data :
      slave6_chip_select_ == `YUTORINA_ENABLE_ ? slave6_read_data :
      slave7_chip_select_ == `YUTORINA_ENABLE_ ? slave7_read_data :
      `YUTORINA_WORD_DATA_WIDTH'h0;
  assign master_ready_
    = slave0_chip_select_ == `YUTORINA_ENABLE_ ? slave0_ready_ :
      slave1_chip_select_ == `YUTORINA_ENABLE_ ? slave1_ready_ :
      slave2_chip_select_ == `YUTORINA_ENABLE_ ? slave2_ready_ :
      slave3_chip_select_ == `YUTORINA_ENABLE_ ? slave3_ready_ :
      slave4_chip_select_ == `YUTORINA_ENABLE_ ? slave4_ready_ :
      slave5_chip_select_ == `YUTORINA_ENABLE_ ? slave5_ready_ :
      slave6_chip_select_ == `YUTORINA_ENABLE_ ? slave6_ready_ :
      slave7_chip_select_ == `YUTORINA_ENABLE_ ? slave7_ready_ :
      `YUTORINA_DISABLE_;
endmodule
