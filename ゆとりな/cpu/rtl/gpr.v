`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "gpr.h"

`timescale 1ns/1ps

module yutorina_gpr(
  input wire clk, input wire rst,
  input wire [`GprAddrBus] rd_addr0, output wire [`WordDataBus] rd_data0,
  input wire [`GprAddrBus] rd_addr1, output wire [`WordDataBus] rd_data1,
  input wire we_,
  input wire [`GprAddrBus] wr_addr, input wire [`WordDataBus] wr_data);
  reg [`WordDataBus] gprs[`GPR_NUM - 1 : 0];
  integer i;
  // 書込みと同時の時は前の値を返す
  assign rd_data0 = gprs[rd_addr0];
  assign rd_data1 = gprs[rd_addr1];
  // レジスタ書込み
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      for (i = 0; i < `GPR_NUM; i = i + 1) begin
        gprs[i] <= #1 `WORD_DATA_W'h0;
      end
    end else begin
      // $0は常にゼロ
      if (we_ == `ENABLE_ && wr_addr != `GPR_ZERO) begin
        gprs[wr_addr] <= #1 wr_data;
      end
    end
  end
endmodule
