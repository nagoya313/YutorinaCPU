`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "sfr.h"

`timescale 1ns/1ps

module yutorina_sfr(
  input wire clk, input wire rst,
  input wire [`SfrAddrBus] rd_addr, output wire [`WordDataBus] rd_data,
  input wire we_,
  input wire [`SfrAddrBus] wr_addr, input wire [`WordDataBus] wr_data);
  reg [`WordDataBus] sfr[`SFR_NUM - 1 : 0];
  integer i;
  assign rd_data = sfr[rd_addr];
  // レジスタ書込み
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      for (i = 0; i < `SFR_NUM; i = i + 1) begin
        sfr[i] <= #1 `WORD_DATA_W'h0;
      end
    end else begin
      if (we_ == `ENABLE_) begin
        sfr[wr_addr] <= #1 wr_data;
        case (wr_addr)
          `SFR_YAPPY: begin // Yappyレジスタ
            $display("Yappy!");
          end `SFR_SPECIAL: begin // 特殊レジスタ
            $display("%d", wr_data);
          end
        endcase
      end
    end
  end
endmodule
