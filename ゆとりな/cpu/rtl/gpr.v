`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"

module yutorina_gpr(
  input wire clock, input wire reset,
  input wire [`YutorinaRegisterAddressBus] read_address0,
  output wire [`YutorinaWordDataBus] read_data0,
  input wire [`YutorinaRegisterAddressBus] read_address1,
  output wire [`YutorinaWordDataBus] read_data1,
  input wire write_enable_,
  input wire [`YutorinaRegisterAddressBus] write_address,
  output wire [`YutorinaWordDataBus] write_data);
  reg [`YutorinaWordDataBus] gprs[`YUTORINA_REGISTER_NUM - 1 : 0];
  integer i;
  // 同じレジスタへの書込みと讀込みが同時だつたら
  // 書込まれたデータを出す
  assign read_data0 = ((write_enable_ == `YUTORINA_ENABLE) &&
                       (write_address == read_address0)) ?
                      write_data : gprs[read_address0];
  assign read_data1 = ((write_enable_ == `YUTORINA_ENABLE) &&
                       (write_address == read_address1)) ?
                      write_data : gprs[read_address1];
  // レジスタ書込み
  // $0は常にゼロ
  always @(posedge clock or `YUTORINA_RESET_EDGE reset) begin
    if (reset == `YUTORINA_RESET_ENABLE) begin
      for (i = 0; i < `YUTORINA_REGISTER_NUM; i = i + 1) begin
        gprs[0] <= #1 `YUTORINA_WORD_DATA_WIDTH'h0;
      end
    end else begin
      if (write_enable_ == `YUTORINA_ENABLE_ &&
          write_address != `YUTORINA_REGISTER_ADDRESS_WIDTH'h0) begin
        gprs[write_address] <= #1 write_data;
      end
    end
  end
endmodule
