`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "bus.h"

module bus_master_multiplexer(
  input wire [`YutorinaWordAddressBus] master0_address,
  input wire master0_address_strobe_,
  input wire master0_read_write,
  input wire [`YutorinaWordDataBus] master0_write_data,
  input wire master0_grant_,
  input wire [`YutorinaWordAddressBus] master1_address,
  input wire master1_address_strobe_,
  input wire master1_read_write,
  input wire [`YutorinaWordDataBus] master1_write_data,
  input wire master1_grant_,
  input wire [`YutorinaWordAddressBus] master2_address,
  input wire master2_address_strobe_,
  input wire master2_read_write,
  input wire [`YutorinaWordDataBus] master2_write_data,
  input wire master2_grant_,
  input wire [`YutorinaWordAddressBus] master3_address,
  input wire master3_address_strobe_,
  input wire master3_read_write,
  input wire [`YutorinaWordDataBus] master3_write_data,
  input wire master3_grant_,
  output wire [`YutorinaWordAddressBus] slave_address,
  output wire slave_address_strobe_,
  output wire slave_read_write,
  output wire [`YutorinaWordDataBus] slave_write_data);
  // バス權を持つてゐるマスタの選擇
  assign slave_address
    = master0_grant_ == `YUTORINA_ENABLE_ ? master0_grant_ :
      master1_grant_ == `YUTORINA_ENABLE_ ? master1_grant_ :
      master2_grant_ == `YUTORINA_ENABLE_ ? master2_grant_ :
      master3_grant_ == `YUTORINA_ENABLE_ ? master3_grant_ :
	    `YUTORINA_WORD_ADDRESS_WIDTH'h0;
	assign slave_address_strobe_ 
	  = master0_grant_ == `YUTORINA_ENABLE_ ? master0_address_strobe_ :
      master1_grant_ == `YUTORINA_ENABLE_ ? master1_address_strobe_ :
      master2_grant_ == `YUTORINA_ENABLE_ ? master2_address_strobe_ :
      master3_grant_ == `YUTORINA_ENABLE_ ? master3_address_strobe_ :
	    `YUTORINA_DISABLE_;
	assign slave_read_write
	  = master0_read_write == `YUTORINA_ENABLE_ ? master0_read_write :
      master1_read_write == `YUTORINA_ENABLE_ ? master1_read_write :
      master2_read_write == `YUTORINA_ENABLE_ ? master2_read_write :
      master3_read_write == `YUTORINA_ENABLE_ ? master3_read_write :
	    `YUTORINA_READ;
	assign slave_write_data 
	  = master0_write_data == `YUTORINA_ENABLE_ ? master0_write_data :
      master1_write_data == `YUTORINA_ENABLE_ ? master1_write_data :
      master2_write_data == `YUTORINA_ENABLE_ ? master2_write_data :
      master3_write_data == `YUTORINA_ENABLE_ ? master3_write_data :
	    `YUTORINA_WORD_DATA_WIDTH'h0;
endmodule
